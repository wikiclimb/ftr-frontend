// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:wikiclimb_flutter_frontend/core/utils/locator.dart';
import 'package:wikiclimb_flutter_frontend/core/widgets/decoration/photo_sliver_app_bar.dart';
import 'package:wikiclimb_flutter_frontend/features/area/presentation/widgets/area_details_list.dart';
import 'package:wikiclimb_flutter_frontend/features/area/presentation/widgets/area_details_tab.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/entities/authentication_data.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/image/presentation/bloc/list/image_list_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/inputs/inputs.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/node.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/usecases/edit_node.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/bloc/node_edit/node_edit_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/screens/edit_node_screen.dart';

import '../../../../fixtures/image/images.dart';
import '../../../../fixtures/node/nodes.dart';

class MockAuthenticationBloc
    extends MockBloc<AuthenticationEvent, AuthenticationState>
    implements AuthenticationBloc {}

class MockNodeEditBloc extends MockBloc<NodeEditEvent, NodeEditState>
    implements NodeEditBloc {}

class MockEditNode extends Mock implements EditNode {}

class MockLocator extends Mock implements Locator {}

class MockImageListBloc extends MockBloc<ImageListEvent, ImageListState>
    implements ImageListBloc {}

class FakeAuthenticationState extends Fake implements AuthenticationState {}

extension on WidgetTester {
  Future<void> pumpIt({
    required AuthenticationBloc mockAuthBloc,
    required NodeEditBloc mockNodeEditBloc,
    required Node node,
  }) {
    return pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<AuthenticationBloc>(create: (context) => mockAuthBloc),
            BlocProvider<NodeEditBloc>(create: (context) => mockNodeEditBloc),
          ],
          child: Scaffold(
            body: AreaDetailsTab(node),
          ),
        ),
      ),
    );
  }
}

void main() {
  late final AuthenticationBloc mockAuthBloc;
  late final ImageListBloc mockImageListBloc;
  late final Locator mockLocator;
  late final NodeEditBloc mockNodeEditBloc;
  const tAuthData = AuthenticationData(
    token: 'token',
    id: 123,
    username: 'test-username',
  );

  setUpAll(() async {
    final sl = GetIt.instance;
    mockLocator = MockLocator();
    sl.registerFactoryParam<NodeEditBloc, Node, void>(
      (node, _) => NodeEditBloc(
        editNode: MockEditNode(),
        locator: mockLocator,
        node: node,
      ),
    );
    registerFallbackValue(FakeAuthenticationState());
    mockImageListBloc = MockImageListBloc();
    when(() => mockImageListBloc.state).thenAnswer(
      (_) => ImageListState(
        status: ImageListStatus.initial,
        images: BuiltSet(images),
        hasError: false,
        nextPage: 1,
      ),
    );
    sl.registerLazySingleton<ImageListBloc>(() => mockImageListBloc);
    mockAuthBloc = MockAuthenticationBloc();
    when(() => mockAuthBloc.state)
        .thenAnswer((_) => AuthenticationAuthenticated(tAuthData));
    mockNodeEditBloc = MockNodeEditBloc();
    when(() => mockNodeEditBloc.state)
        .thenAnswer((_) => _getInitialState(nodes.first));
  });

  testWidgets('screen renders', (tester) async {
    await mockNetworkImagesFor(
      () => tester.pumpIt(
        mockAuthBloc: mockAuthBloc,
        mockNodeEditBloc: mockNodeEditBloc,
        node: nodes.first,
      ),
    );
    expect(find.byType(AreaDetailsTab), findsOneWidget);
  });

  testWidgets('app bar renders using parameter data', (tester) async {
    await mockNetworkImagesFor(
      () => tester.pumpIt(
        mockAuthBloc: mockAuthBloc,
        mockNodeEditBloc: mockNodeEditBloc,
        node: nodes.first,
      ),
    );
    expect(find.byType(PhotoSliverAppBar), findsOneWidget);
    expect(find.byType(AreaDetailsList), findsOneWidget);
    expect(find.byIcon(Icons.star), findsNWidgets(4));
    expect(find.byIcon(Icons.star_half), findsOneWidget);
  });

  group('edit fab', () {
    testWidgets('displays for authenticated users', (tester) async {
      when(() => mockAuthBloc.state)
          .thenAnswer((_) => AuthenticationAuthenticated(tAuthData));
      await mockNetworkImagesFor(
        () => tester.pumpIt(
          mockAuthBloc: mockAuthBloc,
          mockNodeEditBloc: mockNodeEditBloc,
          node: nodes.first,
        ),
      );
      expect(find.byKey(Key('areaDetailsScreen_editArea_fab')), findsOneWidget);
    });

    testWidgets('does not display for guest users', (tester) async {
      when(() => mockAuthBloc.state)
          .thenAnswer((_) => AuthenticationUnauthenticated());
      await mockNetworkImagesFor(
        () => tester.pumpIt(
          mockAuthBloc: mockAuthBloc,
          mockNodeEditBloc: mockNodeEditBloc,
          node: nodes.first,
        ),
      );
      expect(find.byKey(Key('areaDetailsScreen_editArea_fab')), findsNothing);
    });

    testWidgets('navigates to edit page on tap', (tester) async {
      when(() => mockAuthBloc.state)
          .thenAnswer((_) => AuthenticationAuthenticated(tAuthData));
      await mockNetworkImagesFor(
        () => tester.pumpIt(
          mockAuthBloc: mockAuthBloc,
          mockNodeEditBloc: mockNodeEditBloc,
          node: nodes.first,
        ),
      );
      final fabFinder = find.byKey(Key('areaDetailsScreen_editArea_fab'));
      expect(fabFinder, findsOneWidget);
      await tester.tap(fabFinder);
      await tester.pumpAndSettle();
      expect(find.byType(EditNodeScreen), findsOneWidget);
    });
  });
}

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