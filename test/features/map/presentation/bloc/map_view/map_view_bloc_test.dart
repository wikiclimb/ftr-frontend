// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:built_collection/built_collection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wikiclimb_flutter_frontend/core/collections/page.dart';
import 'package:wikiclimb_flutter_frontend/core/error/failure.dart';
import 'package:wikiclimb_flutter_frontend/features/map/domain/usecases/fetch_areas_with_bounds.dart';
import 'package:wikiclimb_flutter_frontend/features/map/presentation/bloc/map_view/map_view_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/node.dart';

import '../../../../../fixtures/area/area_pages.dart';
import '../../../../../fixtures/map/map_nodes.dart';

class MockUsecase extends Mock implements FetchAreasWithBounds {}

class MockMapPosition extends Mock implements MapPosition {}

class MockLatLngBounds extends Mock implements LatLngBounds {}

void main() {
  late FetchAreasWithBounds mockUsecase;
  late MapPosition tPosition;
  late LatLngBounds tBounds;
  const tNorth = 42.2;
  const tEast = 10.35;
  const tSouth = 20.73;
  const tWest = -11.54;
  final List<Node> tNodes = mapNodes;

  setUpAll(() {
    registerFallbackValue(MockMapPosition());
  });

  setUp(() {
    mockUsecase = MockUsecase();
    when(() => mockUsecase.subscribe).thenAnswer((_) => Stream.empty());
    tBounds = MockLatLngBounds();
    when(() => tBounds.north).thenReturn(tNorth);
    when(() => tBounds.east).thenReturn(tEast);
    when(() => tBounds.south).thenReturn(tSouth);
    when(() => tBounds.west).thenReturn(tWest);
    tPosition = MockMapPosition();
    when(() => tPosition.bounds).thenReturn(tBounds);
  });

  test('initial state', () {
    expect(
      MapViewBloc(fetchAreasWithBounds: mockUsecase).state,
      MapViewState(
        status: MapViewStatus.initial,
        nodes: BuiltSet(),
      ),
    );
    verify(() => mockUsecase.subscribe).called(1);
  });

  group('more data requested', () {
    final tState = MapViewState(
      status: MapViewStatus.loaded,
      nodes: BuiltSet(tNodes),
    );

    blocTest<MapViewBloc, MapViewState>(
      'data requests are forwarded',
      seed: () => tState,
      build: () => MapViewBloc(fetchAreasWithBounds: mockUsecase),
      act: (bloc) => bloc.add(MapPositionChanged(position: tPosition)),
      wait: Duration(milliseconds: 600),
      expect: () => <MapViewState>[
        tState.copyWith(status: MapViewStatus.loading),
      ],
      verify: (_) => {
        verify(
          () => mockUsecase.fetch(
            position: tPosition,
            nodes: BuiltSet(tNodes),
            params: null,
          ),
        ).called(1)
      },
    );
  });

  group('response received', () {
    final Page<Node> tPage = areaPages.first;
    blocTest<MapViewBloc, MapViewState>(
      'successful data received',
      setUp: () => when(() => mockUsecase.subscribe).thenAnswer(
        (_) => Stream.value(Right(tPage)),
      ),
      build: () => MapViewBloc(fetchAreasWithBounds: mockUsecase),
      expect: () => <MapViewState>[
        MapViewState(
          status: MapViewStatus.loaded,
          nodes: tPage.items.toBuiltSet(),
        )
      ],
    );

    blocTest<MapViewBloc, MapViewState>(
      'error data received',
      setUp: () => when(() => mockUsecase.subscribe).thenAnswer(
        (_) => Stream.value(Left(NetworkFailure())),
      ),
      build: () => MapViewBloc(fetchAreasWithBounds: mockUsecase),
      expect: () => <MapViewState>[
        MapViewState(
          status: MapViewStatus.failure,
          nodes: BuiltSet(),
        )
      ],
    );
  });
}
