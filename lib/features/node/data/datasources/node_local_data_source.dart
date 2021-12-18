import 'package:built_collection/built_collection.dart';

import '../../../../core/collections/page.dart';
import '../../../../core/database/database.dart';
import '../../domain/entities/node_fetch_params.dart';
import 'drift_node_dao.dart';

/// Local data source for [Node] data.
abstract class NodeLocalDataSource {
  Future<Page<DriftNode>> fetchAll(NodeFetchParams params);

  Future<int> saveAll(BuiltList<DriftNode> nodes);
}

/// Provides implementations to the methods exposed on [NodeLocalDataSource].
class NodeLocalDataSourceImpl extends NodeLocalDataSource {
  NodeLocalDataSourceImpl({required this.driftNodesDao});

  final DriftNodeDao driftNodesDao;

  @override
  Future<Page<DriftNode>> fetchAll(NodeFetchParams params) async {
    List<DriftNode> result = await driftNodesDao.fetch(params);
    return Page((p) => p
      ..isLastPage = false
      ..pageNumber = params.page
      ..nextPageNumber = params.page + 1
      ..items = BuiltList<DriftNode>(result).toBuilder());
  }

  @override
  Future<int> saveAll(BuiltList<DriftNode> nodes) async {
    int inserts = 0;
    for (final n in nodes) {
      driftNodesDao.createOrUpdateNode(n);
      inserts++;
    }
    return inserts;
  }
}
