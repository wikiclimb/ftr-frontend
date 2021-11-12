import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:wikiclimb_flutter_frontend/features/login/domain/entities/username.dart';

main() {
  test('validation should pass for valid username', () {
    const Username username = Username.pure();
    expect(username.validator('username'), equals(null));
  });

  test('validation should pass for valid username', () {
    const Username username = Username.pure();
    expect(username.validator(''), UsernameValidationError.empty);
  });

  test('status outputs correctly', () {
    const Username username = Username.dirty('username');
    expect(username.status, FormzInputStatus.valid);
  });
}
