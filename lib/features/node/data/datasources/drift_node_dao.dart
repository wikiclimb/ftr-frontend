import 'package:drift/drift.dart';

import '../../../../core/database/database.dart';
import '../models/drift_node.dart';

part 'drift_node_dao.g.dart';

/// Dao for [Node] data.
@DriftAccessor(tables: [DriftNodes])
class DriftNodesDao extends DatabaseAccessor<WkcDatabase>
    with _$DriftNodesDaoMixin {
  DriftNodesDao(WkcDatabase db) : super(db);

  /// Fetch a limited amount of [DriftNode] rows.
  ///
  /// This method takes a limit parameter and an optional offset allowing to
  /// fetch paginated results. Limit does not have a default value because it
  /// is the responsibility of the caller to know the number of items needed.
  Future<List<DriftNode>> fetchLimited(int limit, {int? offset}) {
    return (select(driftNodes)..limit(limit, offset: offset)).get();
  }

  /// Fetch a limited amount of [DriftNode] rows filtered by a query string.
  ///
  /// This method takes a [String] that contains a value to filter the records
  /// by, it also takes a limit parameter and an optional offset allowing to
  /// fetch paginated results. Limit does not have a default value because it
  /// is the responsibility of the caller to know the number of items needed.
  Future<List<DriftNode>> fetchLimitedByQuery(
      {required int limit, required String query, int? offset}) {
    return (select(driftNodes)
          ..where((n) => n.name.like(query) | n.description.like(query))
          ..limit(limit, offset: offset))
        .get();
  }

  // TODO complete this method and its tests.
  Future<int> createOrUpdateNode(DriftNode driftNode) {
    return into(driftNodes).insertOnConflictUpdate(driftNode);
  }
}
