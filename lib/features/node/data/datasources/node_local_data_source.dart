import 'package:built_collection/built_collection.dart';

import '../../../../core/database/database.dart';
import 'drift_node_dao.dart';

/// Local data source for [Node] data.
abstract class NodeLocalDataSource {
  Future<int> saveAll(BuiltList<DriftNode> nodes);

  Future<List<DriftNode>> fetchAll();
}

/// Implement the contracts exposed on [NodeLocalDataSource].
class NodeLocalDataSourceImpl extends NodeLocalDataSource {
  NodeLocalDataSourceImpl({required this.driftNodesDao});

  final DriftNodesDao driftNodesDao;

  @override
  Future<int> saveAll(BuiltList<DriftNode> nodes) async {
    int inserts = 0;
    for (final n in nodes) {
      driftNodesDao.createOrUpdateNode(n);
      inserts++;
    }
    return inserts;
  }

  @override
  Future<List<DriftNode>> fetchAll({int page = 1, int offset = 0}) {
    return driftNodesDao.fetchAllNodes();
  }
}
