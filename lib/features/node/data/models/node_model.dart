// ignore_for_file: overridden_fields
// Need to override the fields for them to register with Json serializer.

import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/node.dart';

part 'node_model.g.dart';

@JsonSerializable()
class NodeModel extends Node {
  const NodeModel({
    id,
    required type,
    this.parentId,
    required name,
    required description,
    rating,
    this.breadcrumbs,
    this.pointId,
    this.coverUrl,
    required this.createdBy,
    required this.createdAt,
    this.updatedBy,
    this.updatedAt,
  }) : super(
          id: id,
          type: type,
          parentId: parentId,
          name: name,
          description: description,
          rating: rating,
          breadcrumbs: breadcrumbs,
          pointId: parentId,
          coverUrl: coverUrl,
          createdBy: createdBy,
          createdAt: createdAt,
          updatedBy: updatedBy,
          updatedAt: updatedAt,
        );

  factory NodeModel.fromJson(Map<String, dynamic> json) =>
      _$NodeModelFromJson(json);

  @override
  final List<String>? breadcrumbs;
  @override
  @JsonKey(name: 'parent_id')
  final int? parentId;
  @override
  @JsonKey(name: 'cover_url')
  final String? coverUrl;

  @override
  @JsonKey(name: 'point_id')
  final int? pointId;

  @override
  @JsonKey(name: 'created_by')
  final String createdBy;

  @override
  @JsonKey(name: 'created_at')
  final int createdAt;
  @override
  @JsonKey(name: 'updated_by')
  final String? updatedBy;

  @override
  @JsonKey(name: 'updated_at')
  final int? updatedAt;

  Map<String, dynamic> toJson() => _$NodeModelToJson(this);
}
