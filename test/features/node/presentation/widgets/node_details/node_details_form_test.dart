// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:wikiclimb_flutter_frontend/features/area/presentation/screens/area_details_screen.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/entities/authentication_data.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/image/presentation/bloc/list/image_list_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/bloc/node_edit/node_edit_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/widgets/node_details/node_details_form.dart';

import '../../../../../fixtures/node/nodes.dart';

class MockAuthenticationBloc
    extends MockBloc<AuthenticationEvent, AuthenticationState>
    implements AuthenticationBloc {}

class MockImageListBloc extends MockBloc<ImageListEvent, ImageListState>
    implements ImageListBloc {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class FakeAuthenticationState extends Fake implements AuthenticationState {}

extension on WidgetTester {
  Future<void> pumpForm({
    required NodeEditBloc nodeEditBloc,
    required AuthenticationBloc authenticationBloc,
  }) {
    return pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<NodeEditBloc>(create: (context) => nodeEditBloc),
          BlocProvider<AuthenticationBloc>(
              create: (context) => authenticationBloc),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: NodeDetailsForm(),
          ),
        ),
      ),
    );
  }
}

class MockNodeEditBloc extends MockBloc<NodeEditEvent, NodeEditState>
    implements NodeEditBloc {}

class FakeRoute extends Fake implements Route<dynamic> {}

main() {
  late final MockAuthenticationBloc mockAuthBloc;
  const tAuthData = AuthenticationData(
    token: 'token',
    id: 123,
    username: 'test-username',
  );
  late NodeEditBloc mockNodeEditBloc;
  late final ImageListBloc mockImageListBloc;

  setUpAll(() {
    registerFallbackValue(FakeRoute());
    registerFallbackValue(FakeAuthenticationState());
    mockAuthBloc = MockAuthenticationBloc();
    when(() => mockAuthBloc.state)
        .thenAnswer((_) => AuthenticationAuthenticated(tAuthData));
    mockImageListBloc = MockImageListBloc();
    when(() => mockImageListBloc.state).thenAnswer(
      (_) => ImageListState(
        status: ImageListStatus.initial,
        images: BuiltSet(),
        hasError: false,
        nextPage: 1,
      ),
    );
    GetIt.I.registerLazySingleton<ImageListBloc>(() => mockImageListBloc);
  });

  setUp(() {
    mockNodeEditBloc = MockNodeEditBloc();
    when(() => mockNodeEditBloc.state).thenAnswer((_) => NodeEditState());
  });

  testWidgets('creates the widget', (WidgetTester tester) async {
    await tester.pumpForm(
      nodeEditBloc: mockNodeEditBloc,
      authenticationBloc: mockAuthBloc,
    );
    expect(find.byType(NodeDetailsForm), findsOneWidget);
  });

  group('form submission', () {
    testWidgets('displays loading indicator', (tester) async {
      whenListen(
        mockNodeEditBloc,
        Stream.fromIterable([
          const NodeEditState(status: FormzStatus.submissionInProgress),
          const NodeEditState(status: FormzStatus.submissionSuccess),
        ]),
      );
      when(() => mockNodeEditBloc.state).thenReturn(
        const NodeEditState(status: FormzStatus.submissionInProgress),
      );
      await tester.pumpForm(
        nodeEditBloc: mockNodeEditBloc,
        authenticationBloc: mockAuthBloc,
      );
      // If we wait more frames the success state arrives and hides the loader.
      // await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('failure triggers snackbar', (tester) async {
      whenListen(
        mockNodeEditBloc,
        Stream.fromIterable([
          const NodeEditState(status: FormzStatus.submissionInProgress),
          const NodeEditState(status: FormzStatus.submissionFailure),
        ]),
      );
      when(() => mockNodeEditBloc.state).thenReturn(
        const NodeEditState(status: FormzStatus.submissionFailure),
      );
      await tester.pumpForm(
        nodeEditBloc: mockNodeEditBloc,
        authenticationBloc: mockAuthBloc,
      );
      // Wait for the snackbar animations to complete.
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
      expectLater(find.text('Submission failure'), findsOneWidget);
    });

    testWidgets('success triggers snackbar', (tester) async {
      whenListen(
        mockNodeEditBloc,
        Stream.fromIterable([
          const NodeEditState(status: FormzStatus.submissionInProgress),
          const NodeEditState(status: FormzStatus.submissionSuccess),
        ]),
      );
      when(() => mockNodeEditBloc.state).thenReturn(
        const NodeEditState(status: FormzStatus.submissionSuccess),
      );
      await tester.pumpForm(
        nodeEditBloc: mockNodeEditBloc,
        authenticationBloc: mockAuthBloc,
      );
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
      expectLater(find.text('Submission success'), findsOneWidget);
    });

    testWidgets('success triggers navigation', (tester) async {
      final mockObserver = MockNavigatorObserver();
      whenListen(
        mockNodeEditBloc,
        Stream.fromIterable([
          const NodeEditState(status: FormzStatus.submissionInProgress),
          NodeEditState(
            status: FormzStatus.submissionSuccess,
            node: nodes.first,
          ),
        ]),
      );
      when(() => mockNodeEditBloc.state).thenReturn(
        NodeEditState(status: FormzStatus.submissionSuccess, node: nodes.first),
      );
      await tester.pumpForm(
        nodeEditBloc: mockNodeEditBloc,
        authenticationBloc: mockAuthBloc,
      );
      await mockNetworkImagesFor(
        () => tester.pumpWidget(
          MultiBlocProvider(
            providers: [
              BlocProvider<NodeEditBloc>(
                create: (context) => mockNodeEditBloc,
              ),
              BlocProvider<AuthenticationBloc>(
                create: (context) => mockAuthBloc,
              ),
            ],
            child: MaterialApp(
              navigatorObservers: [mockObserver],
              home: Scaffold(body: NodeDetailsForm()),
            ),
          ),
        ),
      );
      // await tester.pump();
      expectLater(find.byType(SnackBar), findsOneWidget);
      expectLater(find.text('Submission success'), findsOneWidget);
      // The destination route has a circular PI, pumpAndSettle times out.
      await tester.pump();
      // TODO check why NavigatorObserver does not receive the call.
      // verify(() => mockObserver.didPush(any(), any()));
      // pop-and-push removes the AuthBloc from the context, this test fails
      // unless BlocProvider is above MaterialApp on the widget tree.
      expect(find.byType(AreaDetailsScreen), findsOneWidget);
    });
  });

  group('input', () {
    testWidgets('name input triggers event', (tester) async {
      const tName = 'gibberish';
      final nameInput = find.byKey(Key('nodeEditForm_nodeNameInput_textField'));
      await tester.pumpForm(
        nodeEditBloc: mockNodeEditBloc,
        authenticationBloc: mockAuthBloc,
      );
      expect(nameInput, findsOneWidget);
      await tester.enterText(nameInput, tName);
      verify(() => mockNodeEditBloc.add(NodeNameChanged(tName)));
    });

    testWidgets('description input triggers event', (tester) async {
      const tDescription = 'gibberish';
      final textInput = find.byKey(
        Key('nodeEditForm_nodeDescriptionInput_textField'),
      );
      await tester.pumpForm(
        nodeEditBloc: mockNodeEditBloc,
        authenticationBloc: mockAuthBloc,
      );
      expect(textInput, findsOneWidget);
      await tester.enterText(textInput, tDescription);
      verify(() => mockNodeEditBloc.add(NodeDescriptionChanged(tDescription)));
    });

    testWidgets('latitude input triggers event', (tester) async {
      const tLatitude = '-72.31';
      final textInput = find.byKey(
        Key('nodeEditForm_nodeLatitudeInput_textField'),
      );
      await tester.pumpForm(
        nodeEditBloc: mockNodeEditBloc,
        authenticationBloc: mockAuthBloc,
      );
      expect(textInput, findsOneWidget);
      await tester.enterText(textInput, tLatitude);
      verify(() => mockNodeEditBloc.add(NodeLatitudeChanged(tLatitude)));
    });

    testWidgets('longitude input triggers event', (tester) async {
      const tLongitude = '183';
      final textInput = find.byKey(
        Key('nodeEditForm_nodeLongitudeInput_textField'),
      );
      await tester.pumpForm(
        nodeEditBloc: mockNodeEditBloc,
        authenticationBloc: mockAuthBloc,
      );
      expect(textInput, findsOneWidget);
      await tester.enterText(textInput, tLongitude);
      verify(() => mockNodeEditBloc.add(NodeLongitudeChanged(tLongitude)));
    });
  });

  group('submission', () {
    testWidgets('does not trigger event if form is invalid', (tester) async {
      await tester.pumpForm(
        nodeEditBloc: mockNodeEditBloc,
        authenticationBloc: mockAuthBloc,
      );
      await tester.tap(find.byKey(
        Key('nodeEditForm_submitButton_elevatedButton'),
      ));
      verifyNever(() => mockNodeEditBloc.add(NodeSubmissionRequested()));
    });

    testWidgets('if form is valid it triggers the event', (tester) async {
      when(() => mockNodeEditBloc.state).thenAnswer(
        (_) => NodeEditState(status: FormzStatus.valid),
      );
      await tester.pumpForm(
        nodeEditBloc: mockNodeEditBloc,
        authenticationBloc: mockAuthBloc,
      );
      await tester.tap(find.byKey(
        Key('nodeEditForm_submitButton_elevatedButton'),
      ));
      verify(() => mockNodeEditBloc.add(NodeSubmissionRequested())).called(1);
    });
  });
}
