import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:wikiclimb_flutter_frontend/core/entities/form_input/email.dart';

main() {
  const tValid = 'email@example.com';
  const tInvalid = 'emailAtExample.com';

  test('validation should pass for valid email', () {
    const Email email = Email.pure();
    expect(email.validator(tValid), equals(null));
  });

  test('validation should pass for valid email', () {
    const Email email = Email.pure();
    expect(email.validator(tInvalid), EmailValidationError.invalid);
  });

  test('valid regex', () {
    const Email email = Email.dirty(tValid);
    expect(email.status, FormzInputStatus.valid);
  });

  test('invalid regex', () {
    const Email email = Email.dirty(tInvalid);
    expect(email.status, FormzInputStatus.invalid);
  });
}
