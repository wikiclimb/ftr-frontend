import 'package:drift/drift.dart';

import '../../../../core/database/database.dart';
import '../models/drift_node.dart';

part 'drift_node_dao.g.dart';

/// Dao for [Node] data.
@DriftAccessor(tables: [DriftNodes])
class DriftNodesDao extends DatabaseAccessor<WkcDatabase>
    with _$DriftNodesDaoMixin {
  DriftNodesDao(WkcDatabase db) : super(db);

  Future<List<DriftNode>> fetchAllNodes() {
    return select(driftNodes).get();
  }

  Future<int> createOrUpdateNode(DriftNode driftNode) {
    return into(driftNodes).insertOnConflictUpdate(driftNode);
  }
}
