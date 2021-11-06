import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:wikiclimb_flutter_frontend/core/environment/environment_config.dart';
import 'package:wikiclimb_flutter_frontend/core/error/exception.dart';

import 'package:wikiclimb_flutter_frontend/features/authentication/data/datasources/authentication_remote_data_source.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'authentication_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late AuthenticationRemoteDataSource dataSource;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    dataSource = AuthenticationRemoteDataSourceImpl(client: mockClient);
  });

  group('login', () {
    const tUsername = 'test-username';
    const tPassword = 'very-secret';

    test('should send POST request with parameters and header', () async {
      // arrange
      when(mockClient.post(
        any,
        body: anyNamed('body'),
        headers: anyNamed('headers'),
      )).thenAnswer(
        (_) async =>
            http.Response(fixture('authentication/200_response.json'), 200),
      );
      // act
      dataSource.login(username: tUsername, password: tPassword);
      // assert
      verify(mockClient.post(
        Uri.parse('https://${EnvironmentConfig.apiUrl}/login'),
        body: {'username': tUsername, 'password': tPassword},
        headers: {'Content-Type': 'application/json'},
      ));
    });

    test(
      'should throw an UnauthorizedException when response code is 401',
      () async {
        when(mockClient.post(
          any,
          body: anyNamed('body'),
          headers: anyNamed('headers'),
        )).thenAnswer(
          (_) async => http.Response('Unauthorized', 401),
        );
        final call = dataSource.login;
        expect(() => call(username: tUsername, password: tPassword),
            throwsA(const TypeMatcher<UnauthorizedException>()));
      },
    );

    test('should throw a ServerException when response code is 404', () async {
      when(mockClient.post(
        any,
        body: anyNamed('body'),
        headers: anyNamed('headers'),
      )).thenAnswer(
        (_) async => http.Response('Something went wrong', 404),
      );
      final call = dataSource.login;
      expect(() => call(username: tUsername, password: tPassword),
          throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
