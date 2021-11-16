import 'package:built_collection/built_collection.dart';
import 'package:wikiclimb_flutter_frontend/core/collections/page.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/node.dart';

final List<Page<Node>> areaPages = [
  Page((p) => p
    ..items = ListBuilder([
      Node((n) => n
        ..id = 1
        ..type = 1
        ..parentId = null
        ..name = 'test-area-1'
        ..description = 'test-area-1-description'
        ..breadcrumbs = BuiltList<String>().toBuilder()
        ..coverUrl = 'https://placeimg.com/1990'
        ..rating = 4.9
        ..pointId = 7
        ..createdBy = 'test-user-1'
        ..createdAt = 1636879203
        ..updatedBy = 'test-user-1'
        ..updatedAt = 1636899403),
    ])
    ..pageNumber = 1
    ..nextPageNumber = 2
    ..isLastPage = false),
];
