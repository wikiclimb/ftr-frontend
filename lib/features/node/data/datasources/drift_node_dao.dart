import 'package:drift/drift.dart';

import '../../../../core/database/database.dart';
import '../../domain/entities/node_fetch_params.dart';
import '../models/drift_node.dart';

part 'drift_node_dao.g.dart';

/// Dao contracts for [Node] data.
///
/// This class exposes the methods that can be used to fetch and save [Node]
/// data from the local Drift SQLite database.
abstract class DriftNodeDao {
  /// Fetch [DriftNode] rows according to the parameters given.
  ///
  /// Check the documentation for [NodeFetchParams] to see valid parameters that
  /// this method recognizes. The two most important are [page] and [perPage],
  /// because they determine the `limit` and `offset` parameters that the
  /// corresponding SQL query will have.
  Future<List<DriftNode>> fetch(NodeFetchParams params);

  /// Given a [DriftNode] instance, create or update its corresponding row.
  ///
  /// Two [DriftNode] are considered equal if their ID property is the same.
  /// This method needs SQLite version 3.24.0 or above.
  Future<int> createOrUpdateNode(DriftNode driftNode);
}

/// Concrete implementations for the contracts in [DriftNodeDao].
@DriftAccessor(tables: [DriftNodes])
class DriftNodeDaoImpl extends DatabaseAccessor<WkcDatabase>
    with _$DriftNodeDaoImplMixin
    implements DriftNodeDao {
  DriftNodeDaoImpl(WkcDatabase db) : super(db);

  @override
  Future<List<DriftNode>> fetch(NodeFetchParams params) {
    final offset = params.page > 1 ? params.perPage * params.page : 0;
    final sql = select(driftNodes);
    if (params.parentId != null) {
      sql.where((n) => n.parentId.equals(params.parentId));
    }
    if (params.query != null) {
      sql.where((n) =>
          n.name.like(params.query!) | n.description.like(params.query!));
    }
    if (params.type != null) {
      sql.where((n) => n.nodeTypeId.equals(params.type));
    }
    return (sql..limit(params.perPage, offset: offset)).get();
  }

  @override
  Future<int> createOrUpdateNode(DriftNode driftNode) {
    return into(driftNodes).insertOnConflictUpdate(driftNode);
  }
}
