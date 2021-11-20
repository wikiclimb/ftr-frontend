library node_model;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/node.dart';

import '../../../../core/utils/serializers.dart';

part 'node_model.g.dart';

abstract class NodeModel implements Built<NodeModel, NodeModelBuilder> {
  factory NodeModel([void Function(NodeModelBuilder) updates]) = _$NodeModel;

  NodeModel._();

  // Fields

  int? get id;

  int get type;

  @BuiltValueField(wireName: 'parent_id')
  int? get parentId;

  String get name;

  String? get description;

  double? get rating;

  @BuiltValueField(wireName: 'ratings_count')
  double? get ratingsCount;

  BuiltList<String>? get breadcrumbs;

  @BuiltValueField(wireName: 'cover_url')
  String? get coverUrl;

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
      ..pointId = pointId
      ..createdBy = createdBy
      ..createdAt = createdAt
      ..updatedBy = updatedBy
      ..updatedAt = updatedAt);
  }

  static NodeModel? fromJson(String jsonString) {
    return serializers.deserializeWith(
        NodeModel.serializer, json.decode(jsonString));
  }

  static NodeModel? fromNode(Node node) {
    return NodeModel((n) => n
      ..id = node.id
      ..type = node.type
      ..parentId = node.parentId
      ..name = node.name
      ..description = node.description
      ..breadcrumbs = node.breadcrumbs?.toBuilder()
      ..coverUrl = node.coverUrl
      ..rating = node.rating
      ..pointId = node.pointId
      ..createdBy = node.createdBy
      ..createdAt = node.createdAt
      ..updatedBy = node.updatedBy
      ..updatedAt = node.updatedAt);
  }

  static Serializer<NodeModel> get serializer => _$nodeModelSerializer;
}
