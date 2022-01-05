// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:wikiclimb_flutter_frontend/core/entities/response.dart';
import 'package:wikiclimb_flutter_frontend/core/environment/environment_config.dart';
import 'package:wikiclimb_flutter_frontend/core/error/exception.dart';
import 'package:wikiclimb_flutter_frontend/features/password_recovery/data/datasources/password_recovery_remote_data_source.dart';
import 'package:wikiclimb_flutter_frontend/features/password_recovery/domain/entities/password_recovery_params.dart';

class MockClient extends Mock implements http.Client {}

class FakeUri extends Fake implements Uri {}

void main() {
  late http.Client mockClient;
  late PasswordRecoveryRemoteDataSource dataSource;
  final uri = Uri.https(EnvironmentConfig.apiUrl, 'password-recovery');

  const tEmail = 'email@domain.com';
  const successJson = '{"error": false, "message": "OK"}';
  final tParams = PasswordRecoveryParams(email: tEmail);
  final tResponse = Response((r) => r
    ..error = false
    ..message = 'OK');

  setUpAll(() {
    registerFallbackValue(FakeUri());
  });

  setUp(() {
    mockClient = MockClient();
    dataSource = PasswordRecoveryRemoteDataSourceImpl(client: mockClient);
  });

  test('handles success response', () async {
    when(() => mockClient.post(
          any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        )).thenAnswer((_) async => http.Response(successJson, 201));
    final result = await dataSource.requestPasswordRecoveryEmail(tParams);
    expect(result, tResponse);
    verify(() => mockClient.post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: '{"email":"$tEmail"}',
          encoding: null,
        )).called(1);
    verifyNoMoreInteractions(mockClient);
  });

  test('handles failures', () async {
    when(
      () => mockClient.post(
        any(),
        headers: any(named: 'headers'),
        body: any(named: 'body'),
      ),
    ).thenAnswer((_) async => http.Response('false', 500));
    expect(
      () => dataSource.requestPasswordRecoveryEmail(tParams),
      throwsA(TypeMatcher<ServerException>()),
    );
  });
}
