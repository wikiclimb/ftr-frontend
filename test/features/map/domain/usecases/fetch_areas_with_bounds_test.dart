// ignore_for_file: prefer_const_constructors

import 'package:built_collection/built_collection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wikiclimb_flutter_frontend/features/area/domain/repository/area_repository.dart';
import 'package:wikiclimb_flutter_frontend/features/map/domain/usecases/fetch_areas_with_bounds.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/node.dart';

import '../../../../fixtures/area/area_pages.dart';
import '../../../../fixtures/node/nodes.dart';

class MockAreaRepository extends Mock implements AreaRepository {}

class MockMapPosition extends Mock implements MapPosition {}

class MockLatLngBounds extends Mock implements LatLngBounds {}

void main() {
  late final AreaRepository mockAreaRepository;
  late final FetchAreasWithBounds usecase;
  late final MapPosition tPosition;
  late final LatLngBounds tBounds;
  const tNorth = 42.2;
  const tEast = 10.35;
  const tSouth = 20.73;
  const tWest = -11.54;
  final List<Node> tNodes = nodes;
  final tParams = {
    'north': tNorth,
    'east': tEast,
    'south': tSouth,
    'west': tWest,
    'exclude': nodes.map((n) => n.id),
    'bounded': true,
    'per-page': 1000,
  };

  setUpAll(() {
    mockAreaRepository = MockAreaRepository();
    usecase = FetchAreasWithBounds(repository: mockAreaRepository);

    tBounds = MockLatLngBounds();
    when(() => tBounds.north).thenReturn(tNorth);
    when(() => tBounds.east).thenReturn(tEast);
    when(() => tBounds.south).thenReturn(tSouth);
    when(() => tBounds.west).thenReturn(tWest);
    tPosition = MockMapPosition();
    when(() => tPosition.bounds).thenReturn(tBounds);
  });

  setUp(() {});

  test('should forward fetch calls with no params', () async {
    when(() => mockAreaRepository.fetchPage(params: any(named: 'params')))
        .thenAnswer((_) async => Right(areaPages.first));
    usecase.fetch(position: tPosition, nodes: BuiltSet(tNodes));
    verify(() => mockAreaRepository.fetchPage(params: tParams)).called(1);
  });

  test('should forward fetch calls with params', () async {
    when(() => mockAreaRepository.fetchPage(params: any(named: 'params')))
        .thenAnswer((_) async => Right(areaPages.first));
    usecase.fetch(
      position: tPosition,
      nodes: BuiltSet(tNodes),
      params: {'page': 3},
    );
    final expectedParams = {...tParams, 'page': 3};
    verify(() => mockAreaRepository.fetchPage(params: expectedParams))
        .called(1);
  });
}
