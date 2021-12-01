part of 'registration_bloc.dart';

class RegistrationState extends Equatable {
  const RegistrationState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmedPassword = const ConfirmedPassword.pure(),
    this.status = FormzStatus.pure,
    this.username = const Username.pure(),
  });

  final Email email;
  final Password password;
  final ConfirmedPassword confirmedPassword;
  final FormzStatus status;
  final Username username;

  RegistrationState copyWith({
    FormzStatus? status,
    Email? email,
    Username? username,
    Password? password,
    ConfirmedPassword? confirmedPassword,
  }) {
    return RegistrationState(
      status: status ?? this.status,
      email: email ?? this.email,
      username: username ?? this.username,
      password: password ?? this.password,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
    );
  }

  @override
  List<Object> get props =>
      [email, password, confirmedPassword, status, username];
}
