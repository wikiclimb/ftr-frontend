// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:wikiclimb_flutter_frontend/core/entities/form_input/form_inputs.dart';
import 'package:wikiclimb_flutter_frontend/features/registration/presentation/bloc/registration/registration_bloc.dart';

void main() {
  const tEmail = Email.dirty('email');
  const tUsername = Username.dirty('username');
  const tPassword = Password.dirty('password');
  const tConfirmedPassword = ConfirmedPassword.dirty(
    password: 'password_0',
    value: 'password_0',
  );

  group('RegistrationState', () {
    test('supports value comparisons', () {
      expect(RegistrationState(), RegistrationState());
    });

    test('returns same object when no properties are passed', () {
      expect(RegistrationState().copyWith(), RegistrationState());
    });

    test('returns object with updated status when status is passed', () {
      expect(
        RegistrationState().copyWith(status: FormzStatus.pure),
        RegistrationState(status: FormzStatus.pure),
      );
    });

    test('returns object with updated email when email is passed', () {
      expect(
        RegistrationState().copyWith(email: tEmail),
        RegistrationState(email: tEmail),
      );
    });

    test('returns object with updated username when username is passed', () {
      expect(
        RegistrationState().copyWith(username: tUsername),
        RegistrationState(username: tUsername),
      );
    });

    test('returns object with updated password when password is passed', () {
      expect(
        RegistrationState().copyWith(password: tPassword),
        RegistrationState(password: tPassword),
      );
    });

    test(
        'returns object with updated password repeat when '
        'password repeat is passed', () {
      expect(
        RegistrationState().copyWith(confirmedPassword: tConfirmedPassword),
        RegistrationState(confirmedPassword: tConfirmedPassword),
      );
    });
  });
}
