import 'package:built_collection/built_collection.dart';
import 'package:wikiclimb_flutter_frontend/features/node/data/models/node_model.dart';

final List<NodeModel> nodeModels = [
  NodeModel((n) => n
    ..id = 123
    ..type = 1
    ..parentId = 42
    ..name = 'test-area-3'
    ..description = 'test-area-3-description'
    ..breadcrumbs = BuiltList<String>(['One', 'Three']).toBuilder()
    ..coverUrl = 'https://placeimg.com/1990'
    ..rating = 4.9
    ..pointId = 7
    ..createdBy = 'test-user-2'
    ..createdAt = 1636879203
    ..updatedBy = 'test-user-2'
    ..updatedAt = 1636899403),
  // elementAt(1) matches post_result.json data
  NodeModel((n) => n
    ..id = 123
    ..type = 1
    ..parentId = 4
    ..name = 'test-node'
    ..description = 'test-node-description'
    ..breadcrumbs = BuiltList<String>(['One', 'Two', 'Three']).toBuilder()
    ..coverUrl = 'https://placeholder.com/1243'
    ..rating = 4.9
    ..pointId = 9
    ..createdBy = 'test-user-2'
    ..createdAt = 1636879203
    ..updatedBy = 'test-user-2'
    ..updatedAt = 1636899203),
];
