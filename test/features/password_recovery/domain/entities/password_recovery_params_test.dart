import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:wikiclimb_flutter_frontend/features/password_recovery/domain/entities/password_recovery_params.dart';

void main() {
  const tEmail = 'temail@example.com';
  const tJson = {'email': tEmail};
  final tParams = PasswordRecoveryParams(email: tEmail);

  test('can create', () {
    final params = PasswordRecoveryParams(email: tEmail);
    expect(params, isA<PasswordRecoveryParams>());
    expect(params.email, tEmail);
  });

  test('to json', () {
    expect(tParams.toJson(), tJson);
  });

  test('from json', () {
    expect(PasswordRecoveryParams.fromJson(tJson), tParams);
  });

  test('to json string', () {
    expect(json.encode(tParams.toJson()), '{"email":"$tEmail"}');
  });
}
