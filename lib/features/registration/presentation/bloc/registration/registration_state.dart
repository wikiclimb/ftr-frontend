part of 'registration_bloc.dart';

class RegistrationState extends Equatable {
  const RegistrationState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.passwordRepeat = const Password.pure(),
    this.status = FormzStatus.pure,
    this.username = const Username.pure(),
  });

  final Email email;
  final Password password;
  final Password passwordRepeat;
  final FormzStatus status;
  final Username username;

  RegistrationState copyWith({
    FormzStatus? status,
    Email? email,
    Username? username,
    Password? password,
    Password? passwordRepeat,
  }) {
    return RegistrationState(
      status: status ?? this.status,
      email: email ?? this.email,
      username: username ?? this.username,
      password: password ?? this.password,
      passwordRepeat: passwordRepeat ?? this.passwordRepeat,
    );
  }

  @override
  List<Object> get props => [email, password, passwordRepeat, status, username];
}

enum UsernameValidationError { empty }

class Username extends FormzInput<String, UsernameValidationError> {
  const Username.dirty([String value = '']) : super.dirty(value);

  const Username.pure() : super.pure('');

  @override
  UsernameValidationError? validator(String? value) {
    return value?.isNotEmpty == true ? null : UsernameValidationError.empty;
  }
}

enum PasswordValidationError { empty }

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.dirty([String value = '']) : super.dirty(value);

  const Password.pure() : super.pure('');

  @override
  PasswordValidationError? validator(String? value) {
    return value?.isNotEmpty == true ? null : PasswordValidationError.empty;
  }
}

enum EmailValidationError { empty }

class Email extends FormzInput<String, EmailValidationError> {
  const Email.dirty([String value = '']) : super.dirty(value);

  const Email.pure() : super.pure('');

  @override
  EmailValidationError? validator(String? value) {
    return value?.isNotEmpty == true ? null : EmailValidationError.empty;
  }
}
