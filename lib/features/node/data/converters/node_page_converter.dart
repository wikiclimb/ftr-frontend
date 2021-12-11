import 'package:built_collection/built_collection.dart';
import 'package:wikiclimb_flutter_frontend/core/collections/page.dart';
import 'package:wikiclimb_flutter_frontend/core/database/database.dart';
import 'package:wikiclimb_flutter_frontend/features/node/data/models/node_model.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/node.dart';

/// Utility class to handle conversion between different node data types.
abstract class NodePageConverter {
  /// Convert a [Page<DriftNode>] into a [Page<Node>].
  static Page<Node> nodeFromDriftNode(Page<DriftNode> driftNodesPage) =>
      Page<Node>(
        (p) => p
          ..isLastPage = driftNodesPage.isLastPage
          ..nextPageNumber = driftNodesPage.nextPageNumber
          ..pageNumber = driftNodesPage.pageNumber
          ..items = ListBuilder(driftNodesPage.items
              .map((dn) => NodeModel.fromDriftNode(dn).toNode())),
      );

  /// Convert a [Page<NodeModel>] into a [Page<Node>].
  static Page<Node> nodeFromNodeModel(Page<NodeModel> nodeModelsPage) =>
      Page<Node>(
        (p) => p
          ..isLastPage = nodeModelsPage.isLastPage
          ..nextPageNumber = nodeModelsPage.nextPageNumber
          ..pageNumber = nodeModelsPage.pageNumber
          ..items = ListBuilder(nodeModelsPage.items.map((nm) => nm.toNode())),
      );

  /// Convert a [Page<NodeModel>] into a [Page<DriftNode>].
  static Page<DriftNode> driftNodeFromNodeModel(
          Page<NodeModel> nodeModelsPage) =>
      Page<DriftNode>(
        (p) => p
          ..isLastPage = nodeModelsPage.isLastPage
          ..nextPageNumber = nodeModelsPage.nextPageNumber
          ..pageNumber = nodeModelsPage.pageNumber
          ..items =
              ListBuilder(nodeModelsPage.items.map((nm) => nm.toDriftNode())),
      );
}
