library sign_up_params;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import '../../../../core/utils/serializers.dart';

part 'sign_up_params.g.dart';

/// Entity that contains the information that users need to

abstract class SignUpParams
    implements Built<SignUpParams, SignUpParamsBuilder> {
  factory SignUpParams([void Function(SignUpParamsBuilder) updates]) =
      _$SignUpParams;

  SignUpParams._();

  // Fields
  String get username;

  String get email;

  String get password;

  // Serializing belongs on the data layer but we do not have to maintain any
  // code, consider the `g.dart` file to be the model.
  String toJson() {
    return json
        .encode(serializers.serializeWith(SignUpParams.serializer, this));
  }

  static SignUpParams? fromJson(String jsonString) {
    return serializers.deserializeWith(
        SignUpParams.serializer, json.decode(jsonString));
  }

  static Serializer<SignUpParams> get serializer => _$signUpParamsSerializer;
}
