import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:wikiclimb_flutter_frontend/core/entities/form_input/username.dart';

main() {
  test('validation should pass for valid username', () {
    const Username username = Username.pure();
    expect(username.validator('username'), equals(null));
  });

  test('validation should fail for invalid username', () {
    const Username username = Username.pure();
    expect(username.validator(''), UsernameValidationError.invalid);
  });

  test('status outputs correctly', () {
    const Username username = Username.dirty('username');
    expect(username.status, FormzInputStatus.valid);
  });

  test('valid regex', () {
    const Username username = Username.dirty('username_under_and.dot');
    expect(username.status, FormzInputStatus.valid);
  });

  test('invalid regex', () {
    const Username username = Username.dirty('_username_under_and.dot');
    expect(username.status, FormzInputStatus.invalid);
  });
}
