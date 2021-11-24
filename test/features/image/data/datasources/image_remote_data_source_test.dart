import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import 'package:wikiclimb_flutter_frontend/core/authentication/authentication_provider.dart';
import 'package:wikiclimb_flutter_frontend/core/error/exception.dart';
import 'package:wikiclimb_flutter_frontend/features/image/data/datasources/image_remote_data_source.dart';

import '../../../../fixtures/fixture_reader.dart';
import '../../../../fixtures/headers/links.dart';
import '../../../../fixtures/image/image_model_pages.dart';

class MockClient extends Mock implements http.Client {}

class MockAuthenticationProvider extends Mock
    implements AuthenticationProvider {}

class FakeUri extends Fake implements Uri {}

void main() {
  late ImageRemoteDataSource dataSource;
  late MockClient mockClient;
  late AuthenticationProvider mockAuthenticationProvider;

  setUpAll(() {
    registerFallbackValue(FakeUri());
  });

  setUp(() {
    mockClient = MockClient();
    mockAuthenticationProvider = MockAuthenticationProvider();
    dataSource = ImageRemoteDataSourceImpl(
      client: mockClient,
      authenticationProvider: mockAuthenticationProvider,
    );
  });

  group('fetch all', () {
    test('fetch all returns data', () async {
      when(() => mockClient.get(any())).thenAnswer(
        (_) async => http.Response(
          fixture('image/fetch-all-200.json'),
          200,
          headers: linkHeaders['hasNextPage']!,
        ),
      );
      final expected = imageModelPages.elementAt(2);
      final result = await dataSource.fetchAll({});
      expect(result, expected);
      verify(() => mockClient.get(any())).called(1);
    });

    test('fetch converts server errors to failures', () async {
      when(() => mockClient.get(any())).thenAnswer(
        (_) async => http.Response('Something went wrong', 404),
      );
      expect(
        () async => await dataSource.fetchAll({}),
        throwsA(const TypeMatcher<ServerException>()),
      );
      verify(() => mockClient.get(any())).called(1);
      verifyNoMoreInteractions(mockClient);
    });

    test('fetch converts authentication errors to failures', () async {
      when(() => mockClient.get(any())).thenAnswer(
        (_) async => http.Response('Unauthorized', 401),
      );
      expect(
        () async => await dataSource.fetchAll({}),
        throwsA(const TypeMatcher<UnauthorizedException>()),
      );
      verify(() => mockClient.get(any())).called(1);
      verifyNoMoreInteractions(mockClient);
    });

    test('fetch converts forbidden errors to failures', () async {
      when(() => mockClient.get(any())).thenAnswer(
        (_) async => http.Response('Unauthorized', 403),
      );
      expect(
        () async => await dataSource.fetchAll({}),
        throwsA(const TypeMatcher<ForbiddenException>()),
      );
      verify(() => mockClient.get(any())).called(1);
      verifyNoMoreInteractions(mockClient);
    });

    test('fetch converts network errors to failures', () async {
      when(() => mockClient.get(any())).thenThrow(
        const SocketException('Socket exception'),
      );
      expect(
        () async => await dataSource.fetchAll({}),
        throwsA(const TypeMatcher<NetworkException>()),
      );
      verify(() => mockClient.get(any())).called(1);
      verifyNoMoreInteractions(mockClient);
    });

    test('fetch converts other errors to application failures', () async {
      when(() => mockClient.get(any())).thenThrow(const FormatException());
      expect(
        () async => await dataSource.fetchAll({}),
        throwsA(const TypeMatcher<ApplicationException>()),
      );
      verify(() => mockClient.get(any())).called(1);
      verifyNoMoreInteractions(mockClient);
    });

    test('json serializing errors result in ApplicationException', () async {
      when(() => mockClient.get(any())).thenAnswer(
        (_) async => http.Response(
          fixture('image/fetch-all-200-json-serialize-error.json'),
          200,
          headers: linkHeaders['hasNextPage']!,
        ),
      );
      expect(() async => await dataSource.fetchAll({}),
          throwsA(const TypeMatcher<ApplicationException>()),
          reason: 'second image is missing a name, serializing should throw an '
              'exception that should be rethrown as an ApplicationException');
      verify(() => mockClient.get(any())).called(1);
      verifyNoMoreInteractions(mockClient);
    });
  });
}
