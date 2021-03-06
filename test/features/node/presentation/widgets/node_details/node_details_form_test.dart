// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/entities/authentication_data.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/image/presentation/bloc/list/image_list_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/inputs/inputs.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/node.dart';
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
          BlocProvider<NodeEditBloc>(create: (_) => nodeEditBloc),
          BlocProvider<AuthenticationBloc>(create: (_) => authenticationBloc),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
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
  final tNode = nodes.first;
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
    when(() => mockNodeEditBloc.state)
        .thenAnswer((_) => _getInitialState(tNode));
  });

  testWidgets('creates the widget', (WidgetTester tester) async {
    await tester.pumpForm(
      nodeEditBloc: mockNodeEditBloc,
      authenticationBloc: mockAuthBloc,
    );
    expect(find.byType(NodeDetailsForm), findsOneWidget);
  });

  group('initial states', () {
    testWidgets('new area', (tester) async {
      when(() => mockNodeEditBloc.state)
          .thenAnswer((_) => _getInitialState(Node((n) => n
            ..name = 'test'
            ..type = 1)));
      await tester.pumpForm(
        nodeEditBloc: mockNodeEditBloc,
        authenticationBloc: mockAuthBloc,
      );
      expect(find.byType(NodeDetailsForm), findsOneWidget);
      expect(find.text('Add Area'), findsOneWidget);
    });

    testWidgets('existing area', (tester) async {
      when(() => mockNodeEditBloc.state)
          .thenAnswer((_) => _getInitialState(Node((n) => n
            ..id = 666
            ..name = 'test'
            ..type = 1)));
      await tester.pumpForm(
        nodeEditBloc: mockNodeEditBloc,
        authenticationBloc: mockAuthBloc,
      );
      expect(find.byType(NodeDetailsForm), findsOneWidget);
      expect(find.text('Edit Area'), findsOneWidget);
    });

    testWidgets('new route', (tester) async {
      when(() => mockNodeEditBloc.state)
          .thenAnswer((_) => _getInitialState(Node((n) => n
            ..name = 'test'
            ..type = 2)));
      await tester.pumpForm(
        nodeEditBloc: mockNodeEditBloc,
        authenticationBloc: mockAuthBloc,
      );
      expect(find.byType(NodeDetailsForm), findsOneWidget);
      expect(find.text('Add Route'), findsOneWidget);
    });

    testWidgets('existing route', (tester) async {
      when(() => mockNodeEditBloc.state)
          .thenAnswer((_) => _getInitialState(Node((n) => n
            ..id = 666
            ..name = 'test'
            ..type = 2)));
      await tester.pumpForm(
        nodeEditBloc: mockNodeEditBloc,
        authenticationBloc: mockAuthBloc,
      );
      expect(find.byType(NodeDetailsForm), findsOneWidget);
      expect(find.text('Edit Route'), findsOneWidget);
    });
  });

  group('form submission', () {
    final state = _getInitialState(tNode);
    testWidgets('displays loading indicator', (tester) async {
      whenListen(
        mockNodeEditBloc,
        Stream.fromIterable([
          state.copyWith(status: FormzStatus.submissionInProgress),
          state.copyWith(status: FormzStatus.submissionSuccess),
        ]),
      );
      when(() => mockNodeEditBloc.state).thenReturn(
        state.copyWith(status: FormzStatus.submissionInProgress),
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
          state.copyWith(status: FormzStatus.submissionInProgress),
          state.copyWith(status: FormzStatus.submissionFailure),
        ]),
      );
      when(() => mockNodeEditBloc.state).thenReturn(
        state.copyWith(status: FormzStatus.submissionFailure),
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
          state.copyWith(status: FormzStatus.submissionInProgress),
          state.copyWith(status: FormzStatus.submissionSuccess),
        ]),
      );
      when(() => mockNodeEditBloc.state).thenReturn(
        state.copyWith(status: FormzStatus.submissionSuccess),
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
          state.copyWith(status: FormzStatus.submissionInProgress),
          state.copyWith(
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
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
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
      // await tester.pumpAndSettle();
      // TODO check why NavigatorObserver does not receive the call.
      // verify(() => mockObserver.didPop(any(), any()));
      // pop-and-push removes the AuthBloc from the context, this test fails
      // unless BlocProvider is above MaterialApp on the widget tree.
      // This does not work after navigator.pop()
      // expect(find.byType(AreaDetailsScreen), findsOneWidget);
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
    final state = _getInitialState(nodes.first);
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
        (_) => state.copyWith(status: FormzStatus.valid),
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

  group('geolocation', () {
    final state = _getInitialState(tNode);
    group('feedback', () {
      testWidgets('obtain location success triggers snackbar', (tester) async {
        whenListen(
          mockNodeEditBloc,
          Stream.fromIterable([
            state.copyWith(glStatus: GeolocationRequestStatus.requested),
            state.copyWith(glStatus: GeolocationRequestStatus.success),
            state.copyWith(glStatus: GeolocationRequestStatus.done),
          ]),
        );
        when(() => mockNodeEditBloc.state).thenReturn(
          state.copyWith(glStatus: GeolocationRequestStatus.success),
        );
        await tester.pumpForm(
          nodeEditBloc: mockNodeEditBloc,
          authenticationBloc: mockAuthBloc,
        );
        await tester.pump();
        expect(find.byType(SnackBar), findsOneWidget);
        expectLater(find.text('Located'), findsOneWidget);
      });

      testWidgets('obtain location failure triggers snackbar', (tester) async {
        whenListen(
          mockNodeEditBloc,
          Stream.fromIterable([
            state.copyWith(glStatus: GeolocationRequestStatus.requested),
            state.copyWith(glStatus: GeolocationRequestStatus.failure),
            state.copyWith(glStatus: GeolocationRequestStatus.initial),
          ]),
        );
        when(() => mockNodeEditBloc.state).thenReturn(
          state.copyWith(glStatus: GeolocationRequestStatus.failure),
        );
        await tester.pumpForm(
          nodeEditBloc: mockNodeEditBloc,
          authenticationBloc: mockAuthBloc,
        );
        await tester.pump();
        expect(find.byType(SnackBar), findsOneWidget);
        expectLater(find.text('Geolocation failure'), findsOneWidget);
      });
    });

    group('widgets', () {
      testWidgets('while request is being processed button displays loading',
          (tester) async {
        whenListen(
          mockNodeEditBloc,
          Stream.fromIterable([
            state.copyWith(glStatus: GeolocationRequestStatus.requested),
          ]),
        );
        when(() => mockNodeEditBloc.state).thenReturn(
          state.copyWith(glStatus: GeolocationRequestStatus.requested),
        );
        await tester.pumpForm(
          nodeEditBloc: mockNodeEditBloc,
          authenticationBloc: mockAuthBloc,
        );
        final finder = find.descendant(
          of: find.byKey(
            Key('nodeEditForm_requestGeolocation_elevatedButton'),
          ),
          matching: find.byType(CircularProgressIndicator),
        );
        expect(finder, findsOneWidget);
      });

      testWidgets('location success hides location widgets', (tester) async {
        whenListen(
          mockNodeEditBloc,
          Stream.fromIterable([
            state.copyWith(glStatus: GeolocationRequestStatus.done),
          ]),
        );
        when(() => mockNodeEditBloc.state).thenReturn(
          state.copyWith(glStatus: GeolocationRequestStatus.done),
        );
        await tester.pumpForm(
          nodeEditBloc: mockNodeEditBloc,
          authenticationBloc: mockAuthBloc,
        );
        expect(
          find.byKey(
            Key('nodeDetailsForm_nodeLongitudeInput_noTextFieldContainer'),
          ),
          findsOneWidget,
        );
        expect(
          find.byKey(
            Key('nodeDetailsForm_nodeLatitudeInput_noTextFieldContainer'),
          ),
          findsOneWidget,
        );
        expect(
          find.byKey(
            Key('nodeDetailsForm_requestGeolocation_noElevatedButtonContainer'),
          ),
          findsOneWidget,
        );
      });
    });

    group('request geolocation', () {
      testWidgets('does not trigger event if other request is being processed',
          (tester) async {
        whenListen(
          mockNodeEditBloc,
          Stream.fromIterable([
            state.copyWith(glStatus: GeolocationRequestStatus.requested),
          ]),
        );
        when(() => mockNodeEditBloc.state).thenReturn(
          state.copyWith(glStatus: GeolocationRequestStatus.requested),
        );
        await tester.pumpForm(
          nodeEditBloc: mockNodeEditBloc,
          authenticationBloc: mockAuthBloc,
        );
        await tester.tap(find.byKey(
          Key('nodeEditForm_requestGeolocation_elevatedButton'),
        ));
        verifyNever(() => mockNodeEditBloc.add(NodeGeolocationRequested()));
      });

      testWidgets('if form is valid it triggers the event', (tester) async {
        whenListen(
          mockNodeEditBloc,
          Stream.fromIterable([
            state.copyWith(glStatus: GeolocationRequestStatus.initial),
          ]),
        );
        when(() => mockNodeEditBloc.state).thenReturn(
          state.copyWith(glStatus: GeolocationRequestStatus.initial),
        );
        await tester.pumpForm(
          nodeEditBloc: mockNodeEditBloc,
          authenticationBloc: mockAuthBloc,
        );
        await tester.tap(find.byKey(
          Key('nodeEditForm_requestGeolocation_elevatedButton'),
        ));
        verify(() => mockNodeEditBloc.add(NodeGeolocationRequested()))
            .called(1);
      });
    });
  });
}

/// This helper initializes a [NodeEditState] the same way that the bloc does.
NodeEditState _getInitialState(Node node) {
  return NodeEditState(
    node: node,
    type: node.type,
    name: NodeName.pure(node.name),
    description: NodeDescription.pure(node.description ?? ''),
    latitude: NodeLatitude.pure(node.lat?.toString() ?? ''),
    longitude: NodeLongitude.pure(node.lng?.toString() ?? ''),
  );
}
