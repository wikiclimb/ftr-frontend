import 'package:drift/drift.dart';

import '../../features/node/data/datasources/drift_node_dao.dart';
import '../../features/node/data/models/drift_node.dart';

part 'database.g.dart';

/// Main application database.
@DriftDatabase(tables: [DriftNodes], daos: [DriftNodesDao])
class WkcDatabase extends _$WkcDatabase {
  WkcDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;
}
