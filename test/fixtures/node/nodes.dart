import 'package:built_collection/built_collection.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/node.dart';

final List<Node> nodes = [
  Node((n) => n
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
  Node((n) => n
    ..id = 1
    ..type = 1
    ..parentId = null
    ..name = 'test-area-1'
    ..description = 'test-area-1-description'
    ..breadcrumbs = BuiltList<String>([]).toBuilder()
    ..coverUrl = 'https://placeimg.com/1990'
    ..rating = 4.9
    ..pointId = 7
    ..createdBy = 'test-user-2'
    ..createdAt = 1636879203
    ..updatedBy = 'test-user-2'
    ..updatedAt = 1636899403),
  Node((n) => n
    ..id = 1234
    ..type = 1
    ..name = 'test-area-2'
    ..description = 'test-area-2-description'
    ..createdBy = 'test-user'
    ..createdAt = 1636899203
    ..updatedBy = 'test-user'
    ..updatedAt = 1636899203),
];
