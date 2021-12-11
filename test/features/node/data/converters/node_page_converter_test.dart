import 'package:built_collection/built_collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wikiclimb_flutter_frontend/core/collections/page.dart';
import 'package:wikiclimb_flutter_frontend/core/database/database.dart';
import 'package:wikiclimb_flutter_frontend/features/node/data/converters/node_page_converter.dart';
import 'package:wikiclimb_flutter_frontend/features/node/data/models/node_model.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/node.dart';

void main() {
  final driftNodesPage = Page<DriftNode>((p) => p
    ..items = ListBuilder([
      DriftNode(
        id: 1,
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
      DriftNode(
        id: 2,
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
      DriftNode(
        id: 3,
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
    ..isLastPage = false);
  final nodeModelsPage = Page<NodeModel>((p) => p
    ..items = ListBuilder([
      NodeModel((n) => n
        ..id = 1
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
      NodeModel((n) => n
        ..id = 2
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
      NodeModel((n) => n
        ..id = 3
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
    ..isLastPage = false);
  final nodePage = Page<Node>((p) => p
    ..items = ListBuilder([
      Node((n) => n
        ..id = 1
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
        ..id = 2
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
        ..id = 3
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
    ..isLastPage = false);

  test('drift to node', () {
    expect(NodePageConverter.nodeFromDriftNode(driftNodesPage), nodePage);
  });

  test('node from node model', () {
    expect(NodePageConverter.nodeFromNodeModel(nodeModelsPage), nodePage);
  });
}
