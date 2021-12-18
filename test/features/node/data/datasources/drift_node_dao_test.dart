import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wikiclimb_flutter_frontend/core/database/database.dart';
import 'package:wikiclimb_flutter_frontend/features/node/data/datasources/drift_node_dao.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/node_fetch_params.dart';

void main() {
  late WkcDatabase database;
  late DriftNodeDao dao;
  final driftNode = DriftNode(
      nodeTypeId: 1, name: 'name', createdAt: 1, createdBy: 'createdBy');
  final childDriftNode = DriftNode(
    nodeTypeId: 1,
    parentId: 1,
    name: 'www',
    createdAt: 1,
    createdBy: 'createdBy',
  );

  setUpAll(() {
    database = WkcDatabase(NativeDatabase.memory());
    dao = DriftNodeDaoImpl(database);
  });

  test('can insert and read', () async {
    final count = await dao.createOrUpdateNode(driftNode);
    expect(count, 1);
    final read = await dao.fetch(NodeFetchParams((p) => p
      ..page = 1
      ..perPage = 20));
    expect(read.length, 1);
    expect(read.first, driftNode.copyWith(id: 1));

    final tDriftNode = driftNode.copyWith(id: 2);
    await dao.createOrUpdateNode(tDriftNode);
    final read2 = await dao.fetch(NodeFetchParams((p) => p
      ..page = 1
      ..perPage = 20));
    expect(read2.length, 2);
    expect(read2.last, tDriftNode.copyWith(id: 2));

    final ids = [for (var i = 10; i <= 100; i++) i];
    for (var id in ids) {
      final insertNode = driftNode.copyWith(id: id);
      await dao.createOrUpdateNode(insertNode);
    }
    final result = await dao.fetch(NodeFetchParams((p) => p
      ..page = 1
      ..perPage = 12));
    expect(result.length, 12);
    await dao.createOrUpdateNode(driftNode.copyWith(id: 1000, name: 'baboon'));
    final filteredResult = await dao.fetch(NodeFetchParams((p) => p
      ..page = 1
      ..perPage = 20
      ..query = 'baboon'));
    expect(filteredResult.length, 1);
    // Add a child Node
    await dao.createOrUpdateNode(childDriftNode);
    final childResult = await dao.fetch(NodeFetchParams((p) => p
      ..page = 1
      ..parentId = 1
      ..perPage = 100));
    expect(childResult.length, 1);
    final params = NodeFetchParams((p) => p
      ..page = 1
      ..query = 'www'
      ..parentId = 1
      ..perPage = 100);
    final filteredChildResult = await dao.fetch(params);
    expect(filteredChildResult.length, 1);
    expect(
      filteredChildResult.first,
      childDriftNode.copyWith(id: childResult.first.id),
    );

    // Test filtered results by type
    final routeNode = DriftNode(
      nodeTypeId: 2,
      name: 'route-name',
      createdAt: 1,
      createdBy: 'createdBy',
    );
    await dao.createOrUpdateNode(routeNode);
    final routeResult = await dao.fetch(NodeFetchParams((p) => p
      ..page = 1
      ..perPage = 20
      ..type = 2));
    expect(routeResult.length, 1);
  });
}
