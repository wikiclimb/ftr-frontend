import 'package:formz/formz.dart';

/// Validation errors for the [Username] [FormzInput].
enum UsernameValidationError {
  /// Generic invalid error.
  invalid
}

/// {@template username}
/// Form input for an username input.
/// {@endtemplate}
class Username extends FormzInput<String, UsernameValidationError> {
  /// {@macro username}
  const Username.dirty([String value = '']) : super.dirty(value);

  /// {@macro username}
  const Username.pure() : super.pure('');

  static final _usernameRegExp =
      RegExp(r'^(?=.{4,}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$');

  @override
  UsernameValidationError? validator(String? value) {
    return _usernameRegExp.hasMatch(value ?? '')
        ? null
        : UsernameValidationError.invalid;
  }
}
