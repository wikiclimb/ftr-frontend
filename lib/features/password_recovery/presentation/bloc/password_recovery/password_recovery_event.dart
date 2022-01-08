// coverage:ignore-file
part of 'password_recovery_bloc.dart';

@freezed
class PasswordRecoveryEvent with _$PasswordRecoveryEvent {
  const factory PasswordRecoveryEvent.started() = _Started;
  const factory PasswordRecoveryEvent.emailUpdated(String email) =
      _EmailUpdated;
  const factory PasswordRecoveryEvent.submit() = _Submit;
}
