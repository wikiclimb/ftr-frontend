library image_model;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:wikiclimb_flutter_frontend/core/utils/serializers.dart';
import 'package:wikiclimb_flutter_frontend/features/image/domain/entities/image.dart';

part 'image_model.g.dart';

abstract class ImageModel implements Built<ImageModel, ImageModelBuilder> {
  // Fields

  int? get id;

  @BuiltValueField(wireName: 'file_name')
  String get fileName;

  bool? get validated;

  String? get name;

  String? get description;

  @BuiltValueField(wireName: 'created_at')
  int get createdAt;

  @BuiltValueField(wireName: 'created_by')
  String get createdBy;

  int? get pointId;

  @BuiltValueField(wireName: 'updated_at')
  int? get updatedAt;

  @BuiltValueField(wireName: 'updated_by')
  String? get updatedBy;

  ImageModel._();

  factory ImageModel([void Function(ImageModelBuilder) updates]) = _$ImageModel;

  String toJson() {
    return json.encode(serializers.serializeWith(ImageModel.serializer, this));
  }

  Image toImage() {
    return Image((i) => i
      ..id = id
      ..fileName = fileName
      ..validated = validated
      ..name = name
      ..description = description
      ..createdAt = createdAt
      ..createdBy = createdBy
      ..updatedAt = updatedAt
      ..updatedBy = updatedBy);
  }

  static ImageModel? fromJson(String jsonString) {
    return serializers.deserializeWith(
        ImageModel.serializer, jsonDecode(jsonString));
  }

  static ImageModel fromImage(Image image) {
    return ImageModel((i) => i
      ..id = image.id
      ..fileName = image.fileName
      ..validated = image.validated
      ..name = image.name
      ..description = image.description
      ..createdAt = image.createdAt
      ..createdBy = image.createdBy
      ..updatedAt = image.updatedAt
      ..updatedBy = image.updatedBy);
  }

  static Serializer<ImageModel> get serializer => _$imageModelSerializer;
}
