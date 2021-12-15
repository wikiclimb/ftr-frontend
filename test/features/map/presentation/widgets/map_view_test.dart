// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:wikiclimb_flutter_frontend/features/map/presentation/bloc/map_view/map_view_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/map/presentation/widgets/map_view.dart';

import '../../../../fixtures/map/map_nodes.dart';

class MockMapViewBloc extends MockBloc<MapViewEvent, MapViewState>
    implements MapViewBloc {}

class MockMapViewState extends Mock implements MapViewState {}

class FakeMapViewState extends Fake implements MapViewState {}

class FakeMapViewEvent extends Fake implements MapViewEvent {}

extension on WidgetTester {
  Future<void> pumpIt(MapViewBloc mockMapViewBloc) {
    return mockNetworkImagesFor(
      () => pumpWidget(
        MaterialApp(
          home: BlocProvider<MapViewBloc>(
            create: (context) => mockMapViewBloc,
            child: MapView(),
          ),
        ),
      ),
    );
  }
}

void main() {
  late final MapViewBloc mockMapViewBloc;
  late final MapViewState mockMapViewState;

  setUpAll(() async {
    registerFallbackValue(FakeMapViewState());
    registerFallbackValue(FakeMapViewEvent());
    mockMapViewState = MockMapViewState();
    when(() => mockMapViewState.markers).thenReturn([]);
    mockMapViewBloc = MockMapViewBloc();
    when(() => mockMapViewBloc.state).thenAnswer((_) => mockMapViewState);
  });

  testWidgets('widget renders', (tester) async {
    await mockNetworkImagesFor(() => tester.pumpIt(mockMapViewBloc));
    await tester.pumpAndSettle();
    expect(find.byType(MapView), findsOneWidget);
  });

  testWidgets('widget renders marker cluster', (tester) async {
    final state = MapViewState(
      status: MapViewStatus.loaded,
      nodes: BuiltSet(mapNodes),
    );
    when(() => mockMapViewBloc.state).thenAnswer((_) => state);
    await mockNetworkImagesFor(() => tester.pumpIt(mockMapViewBloc));
    await tester.pumpAndSettle();
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('widget renders marker when not clustering', (tester) async {
    final state = MapViewState(
      status: MapViewStatus.loaded,
      nodes: BuiltSet([mapNodes.first]),
    );
    when(() => mockMapViewBloc.state).thenAnswer((_) => state);
    await mockNetworkImagesFor(() => tester.pumpIt(mockMapViewBloc));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.pin_drop), findsOneWidget);
  });

  testWidgets('marker renders popup on tap', (tester) async {
    final state = MapViewState(
      status: MapViewStatus.loaded,
      nodes: BuiltSet([mapNodes.first]),
    );
    when(() => mockMapViewBloc.state).thenAnswer((_) => state);
    await mockNetworkImagesFor(() => tester.pumpIt(mockMapViewBloc));
    await tester.pumpAndSettle();
    final markerFinder = find.byIcon(Icons.pin_drop);
    expect(markerFinder, findsOneWidget);
    await tester.tap(markerFinder);
    await tester.pumpAndSettle();
    expect(find.text('test-map-node-1'), findsOneWidget);
  });

  testWidgets('marker renders popup on tap and dismisses on tap elsewhere',
      (tester) async {
    final state = MapViewState(
      status: MapViewStatus.loaded,
      nodes: BuiltSet([mapNodes.first]),
    );
    when(() => mockMapViewBloc.state).thenAnswer((_) => state);
    await mockNetworkImagesFor(() => tester.pumpIt(mockMapViewBloc));
    await tester.pumpAndSettle();
    final markerFinder = find.byIcon(Icons.pin_drop);
    expect(markerFinder, findsOneWidget);
    await tester.tap(markerFinder);
    await tester.pumpAndSettle();
    expect(find.text('test-map-node-1'), findsOneWidget);
    // Move the marker out of the way
    await tester.drag(find.byType(FlutterMap), const Offset(100.0, 50.0));
    await tester.tap(find.byType(FlutterMap));
    await tester.pumpAndSettle();
    expect(find.text('test-map-node-1'), findsNothing);
  });
}
