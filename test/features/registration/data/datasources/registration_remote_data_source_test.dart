// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:wikiclimb_flutter_frontend/core/entities/response.dart';
import 'package:wikiclimb_flutter_frontend/core/error/exception.dart';
import 'package:wikiclimb_flutter_frontend/features/registration/data/datasources/registration_remote_data_source.dart';
import 'package:wikiclimb_flutter_frontend/features/registration/domain/entities/sign_up_params.dart';

class MockClient extends Mock implements http.Client {}

class FakeUri extends Fake implements Uri {}

void main() {
  late http.Client mockClient;
  late RegistrationRemoteDataSource dataSource;
  const tUsername = 'test-username';

  setUpAll(() {
    registerFallbackValue(FakeUri());
  });

  setUp(() {
    mockClient = MockClient();
    dataSource = RegistrationRemoteDataSourceImpl(client: mockClient);
  });

  group('is username available', () {
    test('when available', () async {
      when(
        () => mockClient.get(
          any(),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => http.Response('true', 200));
      final result = await dataSource.isUsernameAvailable(tUsername);
      expect(result, true);
    });

    test('when not available', () async {
      when(
        () => mockClient.get(
          any(),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => http.Response('false', 200));
      final result = await dataSource.isUsernameAvailable(tUsername);
      expect(result, false);
    });

    test('when exception', () async {
      when(
        () => mockClient.get(
          any(),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => http.Response('false', 500));
      expect(
        () => dataSource.isUsernameAvailable(tUsername),
        throwsA(TypeMatcher<ServerException>()),
      );
    });

    test('deserializing error', () async {
      when(
        () => mockClient.get(
          any(),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => http.Response('false is "false"', 200));
      expect(
        () => dataSource.isUsernameAvailable(tUsername),
        throwsA(TypeMatcher<ApplicationException>()),
      );
    });
  });

  group('register', () {
    final tParams = SignUpParams((p) => p
      ..email = 'email'
      ..username = 'username'
      ..password = 'password');
    final tResponse = Response((r) => r
      ..error = false
      ..message = 'm');

    test('success', () async {
      when(
        () => mockClient.post(
          any(),
          body: any(named: 'body'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => http.Response(tResponse.toJson(), 201));
      final result = await dataSource.register(tParams);
      expect(result, tResponse);
    });

    test('exception', () async {
      when(
        () => mockClient.post(
          any(),
          body: any(named: 'body'),
          headers: any(named: 'headers'),
        ),
      ).thenThrow(SocketException('message'));
      expect(
        () => dataSource.register(tParams),
        throwsA(TypeMatcher<ApplicationException>()),
      );
    });

    test('deserializing error', () async {
      when(
        () => mockClient.post(
          any(),
          body: any(named: 'body'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => http.Response('false,"', 201));
      expect(
        () => dataSource.register(tParams),
        throwsA(
            equals(ApplicationException(message: 'Failed to serialize json'))),
      );
    });
  });
}
