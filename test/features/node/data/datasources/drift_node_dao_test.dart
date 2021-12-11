import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wikiclimb_flutter_frontend/core/database/database.dart';
import 'package:wikiclimb_flutter_frontend/features/node/data/datasources/drift_node_dao.dart';

void main() {
  late WkcDatabase database;
  late DriftNodesDao dao;
  final driftNode = DriftNode(
      nodeTypeId: 1, name: 'name', createdAt: 1, createdBy: 'createdBy');

  setUpAll(() {
    database = WkcDatabase(NativeDatabase.memory());
    dao = DriftNodesDao(database);
  });

  test('can insert new and read', () async {
    final count = await dao.createOrUpdateNode(driftNode);
    expect(count, 1);
    final read = await dao.fetchAllNodes();
    expect(read.length, 1);
    expect(read.first, driftNode.copyWith(id: 1));

    final tDriftNode = driftNode.copyWith(id: 4);
    await dao.createOrUpdateNode(tDriftNode);
    final read2 = await dao.fetchAllNodes();
    expect(read2.length, 2);
    expect(read2.last, tDriftNode.copyWith(id: 4));
  });
}