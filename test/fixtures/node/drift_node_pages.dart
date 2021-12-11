import 'package:built_collection/built_collection.dart';
import 'package:wikiclimb_flutter_frontend/core/collections/page.dart';
import 'package:wikiclimb_flutter_frontend/core/database/database.dart';

final List<Page<DriftNode>> driftNodePages = [
  Page((p) => p
    ..items = ListBuilder([
      DriftNode(
        id: 123,
        nodeTypeId: 1,
        parentId: 42,
        name: 'test-area-3',
        description: 'test-area-3-description',
        breadcrumbs: '["One","Three"]',
        coverUrl: 'https://placeimg.com/1990',
        rating: 4.9,
        pointId: 7,
        createdBy: 'test-user-2',
        createdAt: 1636879203,
        updatedBy: 'test-user-2',
        updatedAt: 1636899403,
      ),
    ])
    ..pageNumber = 1
    ..nextPageNumber = 2
    ..isLastPage = false),
];
