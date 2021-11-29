library response;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import '../../core/utils/serializers.dart';

part 'response.g.dart';

/// Represents a WKC server generic response.
///
/// The response will be of the following form:
/// {
///   "error": true/false,
///   "message": "Hello world!"
/// }
abstract class Response implements Built<Response, ResponseBuilder> {
  factory Response([void Function(ResponseBuilder) updates]) = _$Response;

  Response._();

  // Fields
  String get message;

  bool get error;

  String toJson() {
    return json.encode(serializers.serializeWith(Response.serializer, this));
  }

  static Response? fromJson(String jsonString) {
    return serializers.deserializeWith(
        Response.serializer, json.decode(jsonString));
  }

  static Serializer<Response> get serializer => _$responseSerializer;
}
