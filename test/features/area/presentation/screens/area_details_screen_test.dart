// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:built_collection/built_collection.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:wikiclimb_flutter_frontend/core/utils/locator.dart';
import 'package:wikiclimb_flutter_frontend/features/area/presentation/bloc/list/areas_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/area/presentation/screens/area_details_screen.dart';
import 'package:wikiclimb_flutter_frontend/features/area/presentation/widgets/area_children_tab.dart';
import 'package:wikiclimb_flutter_frontend/features/area/presentation/widgets/area_details_tab.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/entities/authentication_data.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/image/presentation/bloc/list/image_list_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/image/presentation/widgets/node_sliver_image_list.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/inputs/inputs.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/node.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/usecases/edit_node.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/bloc/node_edit/node_edit_bloc.dart';

import '../../../../fixtures/image/images.dart';
import '../../../../fixtures/node/nodes.dart';

class MockAreasBloc extends MockBloc<AreasEvent, AreasState>
    implements AreasBloc {}

class MockAuthenticationBloc
    extends MockBloc<AuthenticationEvent, AuthenticationState>
    implements AuthenticationBloc {}

class MockNodeEditBloc extends MockBloc<NodeEditEvent, NodeEditState>
    implements NodeEditBloc {}

class MockEditNode extends Mock implements EditNode {}

class MockLocator extends Mock implements Locator {}

class MockImageListBloc extends MockBloc<ImageListEvent, ImageListState>
    implements ImageListBloc {}

class FakeAreasState extends Fake implements AreasState {}

class FakeAreasEvent extends Fake implements AreasEvent {}

class FakeAuthenticationState extends Fake implements AuthenticationState {}

extension on WidgetTester {
  Future<void> pumpDetailsScreen({
    required AuthenticationBloc mockAuthBloc,
    required NodeEditBloc mockNodeEditBloc,
  }) {
    return pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<AuthenticationBloc>(create: (context) => mockAuthBloc),
            BlocProvider<NodeEditBloc>(create: (context) => mockNodeEditBloc),
          ],
          child: Scaffold(
            body: AreaDetailsScreen(),
          ),
        ),
      ),
    );
  }
}

void main() {
  late final AreasBloc mockAreasBloc;
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
    registerFallbackValue(FakeAreasState());
    registerFallbackValue(FakeAreasEvent());
    final sl = GetIt.instance;
    mockLocator = MockLocator();
    sl.registerFactoryParam<NodeEditBloc, Node, void>(
      (node, _) => NodeEditBloc(
        editNode: MockEditNode(),
        locator: mockLocator,
        node: node,
      ),
    );
    mockAreasBloc = MockAreasBloc();
    sl.registerFactoryParam<AreasBloc, Node?, void>(
      (parentNode, _) => mockAreasBloc,
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
      () => tester.pumpDetailsScreen(
        mockAuthBloc: mockAuthBloc,
        mockNodeEditBloc: mockNodeEditBloc,
      ),
    );
    expect(find.byType(AreaDetailsScreen), findsOneWidget);
  });

  testWidgets('tabs render', (tester) async {
    await mockNetworkImagesFor(
      () => tester.pumpDetailsScreen(
        mockAuthBloc: mockAuthBloc,
        mockNodeEditBloc: mockNodeEditBloc,
      ),
    );
    expect(find.byType(AreaDetailsTab), findsOneWidget);
  });

  group('cover update notifications', () {
    final state = _getInitialState(nodes.first);

    testWidgets('show snackbar when loading', (tester) async {
      whenListen(
        mockNodeEditBloc,
        Stream.fromIterable([
          state.copyWith(
              coverUpdateRequestStatus: CoverUpdateRequestStatus.initial),
          state.copyWith(
              coverUpdateRequestStatus: CoverUpdateRequestStatus.loading),
        ]),
      );
      when(() => mockNodeEditBloc.state).thenReturn(
        state.copyWith(
          coverUpdateRequestStatus: CoverUpdateRequestStatus.loading,
        ),
      );
      await mockNetworkImagesFor(
        () => tester.pumpDetailsScreen(
          mockAuthBloc: mockAuthBloc,
          mockNodeEditBloc: mockNodeEditBloc,
        ),
      );
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Updating cover image'), findsOneWidget);
    });

    testWidgets('show snackbar when error', (tester) async {
      whenListen(
        mockNodeEditBloc,
        Stream.fromIterable([
          state.copyWith(
              coverUpdateRequestStatus: CoverUpdateRequestStatus.initial),
          state.copyWith(
              coverUpdateRequestStatus: CoverUpdateRequestStatus.loading),
          state.copyWith(
              coverUpdateRequestStatus: CoverUpdateRequestStatus.error),
        ]),
      );
      when(() => mockNodeEditBloc.state).thenReturn(
        state.copyWith(
          coverUpdateRequestStatus: CoverUpdateRequestStatus.error,
        ),
      );
      await mockNetworkImagesFor(
        () => tester.pumpDetailsScreen(
          mockAuthBloc: mockAuthBloc,
          mockNodeEditBloc: mockNodeEditBloc,
        ),
      );
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Error updating cover image'), findsOneWidget);
    });

    testWidgets('show snackbar when success', (tester) async {
      whenListen(
        mockNodeEditBloc,
        Stream.fromIterable([
          state.copyWith(
              coverUpdateRequestStatus: CoverUpdateRequestStatus.initial),
          state.copyWith(
              coverUpdateRequestStatus: CoverUpdateRequestStatus.loading),
          state.copyWith(
              coverUpdateRequestStatus: CoverUpdateRequestStatus.success),
        ]),
      );
      when(() => mockNodeEditBloc.state).thenReturn(
        state.copyWith(
          coverUpdateRequestStatus: CoverUpdateRequestStatus.success,
        ),
      );
      await mockNetworkImagesFor(
        () => tester.pumpDetailsScreen(
          mockAuthBloc: mockAuthBloc,
          mockNodeEditBloc: mockNodeEditBloc,
        ),
      );
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Cover image updated'), findsOneWidget);
    });
  });

  group('image tab', () {
    testWidgets('renders node images', (tester) async {
      await mockNetworkImagesFor(
        () => tester.pumpDetailsScreen(
          mockAuthBloc: mockAuthBloc,
          mockNodeEditBloc: mockNodeEditBloc,
        ),
      );
      await tester.runAsync(() async {
        final bottomBarFinder = find.byType(ConvexAppBar);
        expect(bottomBarFinder, findsOneWidget);
        final tabFinder = find.descendant(
          of: bottomBarFinder,
          matching: find.byIcon(Icons.photo),
        );
        expect(tabFinder, findsOneWidget);
        expect(find.text('Images'), findsOneWidget);
        await tester.tap(tabFinder);
        await tester.pump(Duration(seconds: 1));
        expect(find.text('Images'), findsNothing);
      });
      await tester.pump(Duration(seconds: 1));
      expect(
        find.byKey(Key('areaDetailsScreen_imageListTab_safeArea')),
        findsOneWidget,
      );
      expect(find.byType(NodeSliverImageList), findsOneWidget);
    });
  });

  group('bottom navigation', () {
    testWidgets('can navigate tabs', (tester) async {
      when(() => mockAreasBloc.state).thenAnswer(
        (_) => AreasState(
          status: AreasStatus.initial,
          areas: BuiltSet(),
          hasError: false,
          nextPage: 1,
        ),
      );
      await mockNetworkImagesFor(
        () => tester.pumpDetailsScreen(
          mockAuthBloc: mockAuthBloc,
          mockNodeEditBloc: mockNodeEditBloc,
        ),
      );
      // Tab navigation needs to be async
      await tester.runAsync(() async {
        final bottomBarFinder = find.byType(ConvexAppBar);
        expect(bottomBarFinder, findsOneWidget);
        final tabFinder = find.descendant(
          of: bottomBarFinder,
          matching: find.byIcon(Icons.list),
        );
        expect(tabFinder, findsOneWidget);
        expect(find.text('Explore'), findsOneWidget);
        await tester.tap(tabFinder);
        await tester.pump(Duration(seconds: 1));
        expect(find.text('Explore'), findsNothing);
      });
      await tester.pump(Duration(seconds: 1));
      // await tester.pumpAndSettle();
      expect(find.byType(AreaChildrenTab), findsOneWidget);
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
