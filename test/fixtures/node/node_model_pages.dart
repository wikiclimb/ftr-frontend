import 'package:built_collection/built_collection.dart';
import 'package:wikiclimb_flutter_frontend/core/collections/page.dart';
import 'package:wikiclimb_flutter_frontend/features/node/data/models/node_model.dart';

final List<Page<NodeModel>> nodeModelPages = [
  Page((p) => p
    ..items = ListBuilder([
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
    ])
    ..pageNumber = 1
    ..nextPageNumber = 2
    ..isLastPage = false),
  Page((p) => p
    ..items = ListBuilder([
      NodeModel((n) => n
        ..id = 53
        ..type = 1
        ..name = 'test-area-3'
        ..description = 'test-area-3-description'
        ..coverUrl = 'https://placeimg.com/1990'
        ..rating = 4.9
        ..pointId = 7
        ..createdBy = 'test-user-2'
        ..createdAt = 1636879203
        ..updatedBy = 'test-user-2'
        ..updatedAt = 1636899403),
      NodeModel((n) => n
        ..id = 123
        ..type = 1
        ..parentId = 53
        ..name = 'test-area-4'
        ..description = 'test-area-4-description'
        ..breadcrumbs = BuiltList<String>(['One', 'Three']).toBuilder()
        ..coverUrl = 'https://placeimg.com/19903'
        ..rating = 4.7
        ..pointId = 77
        ..createdBy = 'test-user-2'
        ..createdAt = 1636879203
        ..updatedBy = 'test-user-2'
        ..updatedAt = 1636899403),
    ])
    ..pageNumber = 45
    ..nextPageNumber = 46
    ..isLastPage = false),
];
