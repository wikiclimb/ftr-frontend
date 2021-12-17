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

  final DriftNodesDao driftNodesDao;

  @override
  Future<Page<DriftNode>> fetchAll(NodeFetchParams params) async {
    final offset = params.page > 1 ? params.perPage * params.page : 0;
    final query = params.query;
    // TODO merge this two methdos into one with parameters.
    List<DriftNode> result = query != null
        ? await driftNodesDao.fetchLimitedByQuery(
            limit: params.perPage,
            query: query,
            offset: offset,
            parentId: params.parentId,
          )
        : await driftNodesDao.fetchLimited(
            params.perPage,
            offset: offset,
            parentId: params.parentId,
          );
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
