import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wikiclimb_flutter_frontend/core/database/database.dart';
import 'package:wikiclimb_flutter_frontend/features/node/data/datasources/drift_node_dao.dart';

void main() {
  late WkcDatabase database;
  late DriftNodesDao dao;
  final driftNode = DriftNode(
      nodeTypeId: 1, name: 'name', createdAt: 1, createdBy: 'createdBy');
  const limit = 20;

  setUpAll(() {});

  test('can insert and read', () async {
    // TODO refactor, it will stop working when other tests use the database
    database = WkcDatabase(NativeDatabase.memory());
    dao = DriftNodesDao(database);
    final count = await dao.createOrUpdateNode(driftNode);
    expect(count, 1);
    final read = await dao.fetchLimited(limit);
    expect(read.length, 1);
    expect(read.first, driftNode.copyWith(id: 1));

    final tDriftNode = driftNode.copyWith(id: 2);
    await dao.createOrUpdateNode(tDriftNode);
    final read2 = await dao.fetchLimited(limit);
    expect(read2.length, 2);
    expect(read2.last, tDriftNode.copyWith(id: 2));

    final ids = [for (var i = 10; i <= 100; i++) i];
    for (var id in ids) {
      final insertNode = driftNode.copyWith(id: id);
      await dao.createOrUpdateNode(insertNode);
    }
    final result = await dao.fetchLimited(12);
    expect(result.length, 12);
    await dao.createOrUpdateNode(driftNode.copyWith(id: 1000, name: 'baboon'));
    final filteredResult = await dao.fetchLimitedByQuery(
      limit: 20,
      query: 'baboon',
    );
    expect(filteredResult.length, 1);
  });
}
