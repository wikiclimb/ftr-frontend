library node;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

part 'node.g.dart';

/// Node entity is an information container entity.
///
/// Some important entities, like areas and routes, are modeled using [Node].
abstract class Node implements Built<Node, NodeBuilder> {
  factory Node([void Function(NodeBuilder) updates]) = _$Node;

  Node._();

  // Fields

  int? get id;

  int get type;

  int? get parentId;

  String get name;

  String? get description;

  double? get rating;

  BuiltList<String>? get breadcrumbs;

  String? get coverUrl;

  int get createdAt;

  String get createdBy;

  int? get pointId;

  int? get updatedAt;

  String? get updatedBy;
}
