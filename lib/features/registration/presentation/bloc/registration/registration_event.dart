part of 'registration_bloc.dart';

abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();

  @override
  List<Object> get props => [];
}

class RegistrationEmailChanged extends RegistrationEvent {
  const RegistrationEmailChanged(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}

class RegistrationUsernameChanged extends RegistrationEvent {
  const RegistrationUsernameChanged(this.username);

  final String username;

  @override
  List<Object> get props => [username];
}

class RegistrationPasswordChanged extends RegistrationEvent {
  const RegistrationPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

class RegistrationPasswordRepeatChanged extends RegistrationEvent {
  const RegistrationPasswordRepeatChanged(this.passwordRepeat);

  final String passwordRepeat;

  @override
  List<Object> get props => [passwordRepeat];
}

class RegistrationSubmitted extends RegistrationEvent {
  const RegistrationSubmitted();
}
