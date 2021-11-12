import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:wikiclimb_flutter_frontend/features/login/domain/entities/password.dart';

main() {
  test('validation should pass for valid password', () {
    const Password password = Password.pure();
    expect(password.validator('password'), equals(null));
  });

  test('validation should pass for valid password', () {
    const Password password = Password.pure();
    expect(password.validator(''), PasswordValidationError.empty);
  });

  test('status outputs correctly', () {
    const Password password = Password.dirty('password');
    expect(password.status, FormzInputStatus.valid);
  });
}
