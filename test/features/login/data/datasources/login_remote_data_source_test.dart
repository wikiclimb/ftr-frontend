import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:wikiclimb_flutter_frontend/core/environment/environment_config.dart';
import 'package:wikiclimb_flutter_frontend/core/error/exception.dart';
import 'package:wikiclimb_flutter_frontend/core/network/network_info.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/data/models/authentication_data_model.dart';

import 'package:wikiclimb_flutter_frontend/features/login/data/datasources/login_remote_data_source.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'login_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client, NetworkInfo])
void main() {
  late LoginRemoteDataSource dataSource;
  late MockClient mockClient;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockClient = MockClient();
    mockNetworkInfo = MockNetworkInfo();
    dataSource = LoginRemoteDataSourceImpl(
      client: mockClient,
      networkInfo: mockNetworkInfo,
    );
  });

  group('login', () {
    const tUsername = 'test-username';
    const tPassword = 'very-secret';
    test('should check if the device is online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockClient.post(
        any,
        body: anyNamed('body'),
        headers: anyNamed('headers'),
      )).thenAnswer(
        (_) async =>
            http.Response(fixture('authentication/200_response.json'), 200),
      );
      final result =
          await dataSource.login(username: tUsername, password: tPassword);
      expect(result, isA<AuthenticationDataModel>());
      verify(mockNetworkInfo.isConnected);
    });

    test('should send POST request with parameters and header', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockClient.post(
        any,
        body: anyNamed('body'),
        headers: anyNamed('headers'),
      )).thenAnswer(
        (_) async => http.Response(
          fixture('authentication/200_response.json'),
          200,
        ),
      );
      // act
      final result = await dataSource.login(
        username: tUsername,
        password: tPassword,
      );
      // assert
      expect(result, isA<AuthenticationDataModel>());
      verify(mockClient.post(
        Uri.parse('https://${EnvironmentConfig.apiUrl}/login'),
        body: jsonEncode({
          'username': tUsername,
          'password': tPassword,
        }),
        headers: {'Content-Type': 'application/json'},
      ));
    });

    test('should throw an UnauthorizedException when response code is 401',
        () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockClient.post(
        any,
        body: anyNamed('body'),
        headers: anyNamed('headers'),
      )).thenAnswer(
        (_) async => http.Response('Unauthorized', 401),
      );
      final call = dataSource.login;
      expect(
        () => call(
          username: tUsername,
          password: tPassword,
        ),
        throwsA(const TypeMatcher<UnauthorizedException>()),
      );
    });

    test('should throw a ServerException when response code is 404', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockClient.post(
        any,
        body: anyNamed('body'),
        headers: anyNamed('headers'),
      )).thenAnswer(
        (_) async => http.Response('Something went wrong', 404),
      );
      final call = dataSource.login;
      expect(
        () => call(username: tUsername, password: tPassword),
        throwsA(const TypeMatcher<ServerException>()),
      );
    });

    test('should throw a NetworkException when connection fails', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockClient.post(
        any,
        body: anyNamed('body'),
        headers: anyNamed('headers'),
      )).thenThrow((_) async => const SocketException('Could not connect'));
      final call = dataSource.login;
      expect(
        () => call(username: tUsername, password: tPassword),
        throwsA(const TypeMatcher<NetworkException>()),
      );
    });

    test('should throw network exception when not connected', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      final call = dataSource.login;
      expect(
        () => call(username: tUsername, password: tPassword),
        throwsA(const TypeMatcher<NetworkException>()),
      );
    });
  });
}
