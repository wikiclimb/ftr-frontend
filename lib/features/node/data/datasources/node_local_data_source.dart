import 'package:built_collection/built_collection.dart';

import '../../../../core/collections/page.dart';
import '../../../../core/database/database.dart';
import 'drift_node_dao.dart';

/// Local data source for [Node] data.
abstract class NodeLocalDataSource {
  Future<Page<DriftNode>> fetchAll(Map<String, String> params);

  Future<int> saveAll(BuiltList<DriftNode> nodes);
}

/// Provides implementations to the methods exposed on [NodeLocalDataSource].
class NodeLocalDataSourceImpl extends NodeLocalDataSource {
  NodeLocalDataSourceImpl({required this.driftNodesDao});

  final DriftNodesDao driftNodesDao;

  @override
  Future<Page<DriftNode>> fetchAll(Map<String, String> params) async {
    // TODO too much boilerplate and validity checks, refactor into a Params
    // class with required fields and default values.
    var perPage = 20;
    var offset = 0;
    var pageNumber = 1;
    final perPageString = params['per-page'];
    if (perPageString != null) {
      perPage = int.parse(perPageString);
    }
    final pageString = params['page'];
    if (pageString != null) {
      pageNumber = int.parse(pageString);
      if (pageNumber > 1) {
        offset = perPage * pageNumber;
      }
    }
    final query = params['q'];
    List<DriftNode> result = query != null
        ? await driftNodesDao.fetchLimitedByQuery(
            limit: perPage,
            query: query,
            offset: offset,
            parentId: int.tryParse(params['parent-id'] ?? ''),
          )
        : await driftNodesDao.fetchLimited(
            perPage,
            offset: offset,
            parentId: int.tryParse(params['parent-id'] ?? ''),
          );
    return Page((p) => p
      ..isLastPage = false
      ..pageNumber = pageNumber
      ..nextPageNumber = pageNumber + 1
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
