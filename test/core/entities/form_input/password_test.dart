// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:wikiclimb_flutter_frontend/core/entities/form_input/password.dart';

main() {
  const tValid = 'pa.#!s>P<s_w0rd';
  const tNoNumber = 'password';

  test('validation should pass for valid password', () {
    Password password = Password.pure();
    expect(password.validator(tValid), equals(null));
  });

  test('validation should fail for invalid (no digits) password', () {
    Password password = Password.pure();
    expect(password.validator(tNoNumber), PasswordValidationError.invalid);
  });

  test('valid status outputs correctly', () {
    Password password = Password.dirty(tValid);
    expect(password.status, FormzInputStatus.valid);
  });

  test('invalid status outputs correctly', () {
    Password password = Password.dirty(tNoNumber);
    expect(password.status, FormzInputStatus.invalid);
  });
}
