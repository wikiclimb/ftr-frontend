import 'package:built_collection/built_collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wikiclimb_flutter_frontend/core/collections/page.dart';
import 'package:wikiclimb_flutter_frontend/core/database/database.dart';
import 'package:wikiclimb_flutter_frontend/features/node/data/datasources/drift_node_dao.dart';
import 'package:wikiclimb_flutter_frontend/features/node/data/datasources/node_local_data_source.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/node_fetch_params.dart';

import '../../../../fixtures/node/drift_nodes.dart';

class MockDriftNodesDao extends Mock implements DriftNodeDao {}

void main() {
  late DriftNodeDao mockDao;
  late NodeLocalDataSource dataSource;
  final expectedPage = Page((p) => p
    ..items = BuiltList(driftNodes).toBuilder()
    ..isLastPage = false
    ..nextPageNumber = 2
    ..pageNumber = 1);

  setUpAll(() {
    registerFallbackValue(driftNodes.first);
  });

  setUp(() {
    mockDao = MockDriftNodesDao();
    dataSource = NodeLocalDataSourceImpl(driftNodesDao: mockDao);
  });

  group('fetch', () {
    test('fetch all no params', () async {
      final tParams = NodeFetchParams((p) => p
        ..page = 1
        ..perPage = 20);
      when(() => mockDao.fetch(tParams)).thenAnswer((_) async => driftNodes);
      final result = await dataSource.fetchAll(tParams);
      expect(result, expectedPage);
      verify(() => mockDao.fetch(tParams)).called(1);
    });

    test('fetch all with params', () async {
      final tParams = NodeFetchParams((p) => p
        ..page = 3
        ..perPage = 10);
      when(() => mockDao.fetch(tParams)).thenAnswer((_) async => driftNodes);
      final result = await dataSource.fetchAll(tParams);
      final page = Page((p) => p
        ..items = BuiltList(driftNodes).toBuilder()
        ..isLastPage = false
        ..nextPageNumber = 4
        ..pageNumber = 3);
      expect(result, page);
      verify(() => mockDao.fetch(tParams)).called(1);
    });

    test('fetch all with params and query', () async {
      final tParams = NodeFetchParams((p) => p
        ..page = 3
        ..perPage = 10
        ..query = 'baboon');
      when(() => mockDao.fetch(tParams)).thenAnswer((_) async => driftNodes);
      final result = await dataSource.fetchAll(tParams);
      final page = Page((p) => p
        ..items = BuiltList(driftNodes).toBuilder()
        ..isLastPage = false
        ..nextPageNumber = 4
        ..pageNumber = 3);
      expect(result, page);
      verify(() => mockDao.fetch(tParams)).called(1);
    });
  });

  group('save', () {
    test('list of one element', () async {
      when(() => mockDao.createOrUpdateNode(any())).thenAnswer((_) async => 1);
      final result = await dataSource.saveAll(BuiltList(driftNodes));
      expect(result, 1);
      verify(() => mockDao.createOrUpdateNode(driftNodes.first)).called(1);
    });

    test('list of many elements', () async {
      late final nodesBuilder = ListBuilder<DriftNode>();
      for (var id in [for (var i = 11; i <= 100; i++) i]) {
        final dn = DriftNode(
          id: id,
          nodeTypeId: 1,
          parentId: 42,
          name: 'test-area-3',
          description: 'test-area-3-description',
          breadcrumbs: '["One","Three"]',
          coverUrl: 'https://placeimg.com/1990',
          rating: 4.9,
          pointId: 7,
          createdBy: 'test-user-2',
          createdAt: 1636879203,
          updatedBy: 'test-user-2',
          updatedAt: 1636899403,
        );
        nodesBuilder.add(dn);
      }
      when(() => mockDao.createOrUpdateNode(any())).thenAnswer((_) async => 1);
      final result = await dataSource.saveAll(nodesBuilder.build());
      expect(result, 90);
      verify(() => mockDao.createOrUpdateNode(any())).called(90);
    });
  });
}
