import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/data/models/authentication_data_model.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/entities/authentication_data.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tAuthenticationDataModel =
      AuthenticationDataModel(token: 'test-token', id: 123);

  test('should be a subclass of AuthenticationData', () {
    expect(tAuthenticationDataModel, isA<AuthenticationData>());
  });

  group('fromJson', () {
    test('should return a valid authentication data model', () {
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('authentication/success.json'));
      final result = AuthenticationDataModel.fromJson(jsonMap);
      expect(result, tAuthenticationDataModel);
    });
  });

  group('toJson', () {
    test('should return a json map containing the model data', () {
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('authentication/success.json'));
      final result = tAuthenticationDataModel.toJson();
      expect(result, jsonMap);
    });
  });
}
