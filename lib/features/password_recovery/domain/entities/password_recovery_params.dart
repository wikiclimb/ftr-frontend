// coverage:ignore-file
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'password_recovery_params.freezed.dart';
part 'password_recovery_params.g.dart';

@freezed
class PasswordRecoveryParams with _$PasswordRecoveryParams {
  factory PasswordRecoveryParams({required String email}) =
      _PasswordRecoveryParams;

  factory PasswordRecoveryParams.fromJson(Map<String, dynamic> json) =>
      _$PasswordRecoveryParamsFromJson(json);
}
