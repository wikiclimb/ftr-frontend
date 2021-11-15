import 'package:equatable/equatable.dart';

/// Node entity is an information container entity.
///
/// Some important entities, like areas and routes, are modeled using [Node].
class Node extends Equatable {
  final int? id;
  final int type;
  final int? parentId;
  final String name;
  final String description;
  final double? rating;
  final List<String>? breadcrumbs;
  final int? pointId;
  final String? coverUrl;
  final String createdBy;
  final int createdAt;
  final String? updatedBy;
  final int? updatedAt;

  const Node({
    this.id,
    required this.type,
    this.parentId,
    required this.name,
    required this.description,
    this.rating,
    this.breadcrumbs,
    this.pointId,
    this.coverUrl,
    required this.createdBy,
    required this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        type,
        parentId,
        name,
        description,
        rating,
        breadcrumbs,
        pointId,
        coverUrl,
        createdBy,
        createdAt,
        updatedBy,
        updatedAt,
      ];
}
