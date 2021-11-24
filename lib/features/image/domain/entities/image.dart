library image;

import 'package:built_value/built_value.dart';

part 'image.g.dart';

abstract class Image implements Built<Image, ImageBuilder> {
  factory Image([void Function(ImageBuilder) updates]) = _$Image;

  Image._();

  // Fields

  int? get id;

  String get fileName;

  bool? get validated;

  String? get name;

  String? get description;

  int? get createdAt;

  String? get createdBy;

  int? get updatedAt;

  String? get updatedBy;
}
