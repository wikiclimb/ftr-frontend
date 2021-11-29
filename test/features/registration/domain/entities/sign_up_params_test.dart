import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:wikiclimb_flutter_frontend/features/registration/domain/entities/sign_up_params.dart';

void main() {
  final tParams = SignUpParams((p) => p
    ..username = 'test-username'
    ..email = 'test-email'
    ..password = 'test-password');
  const tJson = '{"username":"test-username","password":"test-password", '
      '"email":"test-email"}';

  test('equality', () {
    final xParams = tParams.rebuild((p0) => p0..email = 'new-email');
    expect(tParams, xParams.rebuild((p0) => p0..email = 'test-email'));
  });

  test('to json', () {
    final actual = tParams.toJson();
    expect(jsonDecode(actual), jsonDecode(tJson));
  });

  test('from json', () {
    expect(SignUpParams.fromJson(tJson), tParams);
  });
}
