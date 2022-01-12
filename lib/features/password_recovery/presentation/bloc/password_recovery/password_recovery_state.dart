// coverage:ignore-file
part of 'password_recovery_bloc.dart';

@freezed
class PasswordRecoveryState with _$PasswordRecoveryState {
  factory PasswordRecoveryState({
    @Default(FormzStatus.pure) FormzStatus status,
    @Default(Email.pure()) Email email,
    String? message,
  }) = _PasswordRecoveryState;
}
