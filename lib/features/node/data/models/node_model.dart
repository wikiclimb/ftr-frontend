library node_model;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:wikiclimb_flutter_frontend/core/database/database.dart';

import '../../../../core/utils/serializers.dart';
import '../../domain/entities/node.dart';

part 'node_model.g.dart';

/// Data layer model for domain [Node] entities.
///
/// Adds support for interacting with the data layer endpoints.
abstract class NodeModel implements Built<NodeModel, NodeModelBuilder> {
  factory NodeModel([void Function(NodeModelBuilder) updates]) = _$NodeModel;

  NodeModel._();

  // Fields

  int? get id;

  @BuiltValueField(wireName: 'node_type_id')
  int get type;

  @BuiltValueField(wireName: 'parent_id')
  int? get parentId;

  String get name;

  String? get description;

  double? get rating;

  @BuiltValueField(wireName: 'ratings_count')
  int? get ratingsCount;

  BuiltList<String>? get breadcrumbs;

  @BuiltValueField(wireName: 'cover_url')
  String? get coverUrl;

  double? get lat;

  double? get lng;

  @BuiltValueField(wireName: 'created_at')
  int get createdAt;

  @BuiltValueField(wireName: 'created_by')
  String get createdBy;

  @BuiltValueField(wireName: 'point_id')
  int? get pointId;

  @BuiltValueField(wireName: 'updated_at')
  int? get updatedAt;

  @BuiltValueField(wireName: 'updated_by')
  String? get updatedBy;

  String toJson() {
    return json.encode(serializers.serializeWith(NodeModel.serializer, this));
  }

  DriftNode toDriftNode() {
    return DriftNode(
        id: id,
        nodeTypeId: type,
        parentId: parentId,
        name: name,
        description: description,
        breadcrumbs: jsonEncode(breadcrumbs?.toList() ?? []),
        coverUrl: coverUrl,
        rating: rating,
        ratingsCount: ratingsCount,
        pointId: pointId,
        lat: lat,
        lng: lng,
        createdAt: createdAt,
        createdBy: createdBy,
        updatedAt: updatedAt,
        updatedBy: updatedBy);
  }

  static NodeModel fromDriftNode(DriftNode driftNode) {
    return NodeModel((n) => n
      ..id = driftNode.id
      ..type = driftNode.nodeTypeId
      ..parentId = driftNode.parentId
      ..name = driftNode.name
      ..description = driftNode.description
      ..breadcrumbs = driftNode.breadcrumbs != null
          ? ListBuilder(jsonDecode(driftNode.breadcrumbs!))
          : null
      ..coverUrl = driftNode.coverUrl
      ..rating = driftNode.rating
      ..ratingsCount = driftNode.ratingsCount
      ..pointId = driftNode.pointId
      ..lat = driftNode.lat
      ..lng = driftNode.lng
      ..createdBy = driftNode.createdBy
      ..createdAt = driftNode.createdAt
      ..updatedBy = driftNode.updatedBy
      ..updatedAt = driftNode.updatedAt);
  }

  /// Return the [Node] corresponding to this [NodeModel].
  Node toNode() {
    return Node((n) => n
      ..id = id
      ..type = type
      ..parentId = parentId
      ..name = name
      ..description = description
      ..breadcrumbs = breadcrumbs?.toBuilder()
      ..coverUrl = coverUrl
      ..rating = rating
      ..ratingsCount = ratingsCount
      ..pointId = pointId
      ..lat = lat
      ..lng = lng
      ..createdBy = createdBy
      ..createdAt = createdAt
      ..updatedBy = updatedBy
      ..updatedAt = updatedAt);
  }

  static NodeModel? fromJson(String jsonString) {
    return serializers.deserializeWith(
        NodeModel.serializer, json.decode(jsonString));
  }

  static NodeModel fromNode(Node node) {
    return NodeModel((n) => n
      ..id = node.id
      ..type = node.type
      ..parentId = node.parentId
      ..name = node.name
      ..description = node.description
      ..breadcrumbs = node.breadcrumbs?.toBuilder()
      ..coverUrl = node.coverUrl
      ..rating = node.rating
      ..ratingsCount = node.ratingsCount
      ..pointId = node.pointId
      ..lat = node.lat
      ..lng = node.lng
      ..createdBy = node.createdBy
      ..createdAt = node.createdAt
      ..updatedBy = node.updatedBy
      ..updatedAt = node.updatedAt);
  }

  static Serializer<NodeModel> get serializer => _$nodeModelSerializer;
}
