// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:wikiclimb_flutter_frontend/core/entities/form_input/confirmed_password.dart';

main() {
  const tValid = 'pa.#!s>P<s_w0rd';

  test('status pure', () {
    const ConfirmedPassword confirmedPassword = ConfirmedPassword.pure();
    expect(confirmedPassword.status, FormzInputStatus.pure);
  });

  test('status valid when passwords match', () {
    const ConfirmedPassword confirmedPassword =
        ConfirmedPassword.dirty(password: tValid, value: tValid);
    expect(
      confirmedPassword.status,
      FormzInputStatus.valid,
    );
  });

  test('status invalid when passwords do not match', () {
    ConfirmedPassword confirmedPassword =
        ConfirmedPassword.dirty(password: tValid, value: 'o$tValid');
    expect(confirmedPassword.status, FormzInputStatus.invalid);
  });
}
