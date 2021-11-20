import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import 'package:wikiclimb_flutter_frontend/core/authentication/authentication_provider.dart';
import 'package:wikiclimb_flutter_frontend/core/error/exception.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/entities/authentication_data.dart';
import 'package:wikiclimb_flutter_frontend/features/node/data/datasources/node_remote_data_source.dart';
import 'package:wikiclimb_flutter_frontend/features/node/data/models/node_model.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/node.dart';

import '../../../../fixtures/fixture_reader.dart';
import '../../../../fixtures/headers/links.dart';
import '../../../../fixtures/node/node_model_pages.dart';
import '../../../../fixtures/node/node_models.dart';

class MockClient extends Mock implements http.Client {}

class MockAuthenticationProvider extends Mock
    implements AuthenticationProvider {}

class FakeUri extends Fake implements Uri {}

void main() {
  late NodeRemoteDataSource dataSource;
  late MockClient mockClient;
  late AuthenticationProvider mockAuthenticationProvider;
  const tAuthData = AuthenticationData(
    token: 'secret-token',
    id: 123,
    username: 'username',
  );

  setUpAll(() {
    registerFallbackValue(FakeUri());
  });

  setUp(() {
    mockClient = MockClient();
    mockAuthenticationProvider = MockAuthenticationProvider();
    dataSource = NodeRemoteDataSourceImpl(
      client: mockClient,
      authenticationProvider: mockAuthenticationProvider,
    );
  });

  group('fetch all', () {
    test('fetch all returns data', () async {
      when(() => mockClient.get(any())).thenAnswer(
        (_) async => http.Response(
          fixture('node/200-1.json'),
          200,
          headers: linkHeaders['hasNextPage']!,
        ),
      );
      final expected = nodeModelPages.elementAt(1);
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
          fixture('node/200-2-with-error-data.json'),
          200,
          headers: linkHeaders['hasNextPage']!,
        ),
      );
      expect(() async => await dataSource.fetchAll({}),
          throwsA(const TypeMatcher<ApplicationException>()),
          reason: 'second node is missing a name, serializing should throw an '
              'exception that should be rethrown as an ApplicationException');
      verify(() => mockClient.get(any())).called(1);
      verifyNoMoreInteractions(mockClient);
    });
  });

  group('create node', () {
    test('successful create', () async {
      final node = Node((n) => n
        ..type = 1
        ..name = 'some name'
        ..parentId = 4);
      final tParam = NodeModel.fromNode(node);
      when(() => mockClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer(
        (_) async => http.Response(
          fixture('node/post_result.json'),
          201,
        ),
      );
      final expected = nodeModels.elementAt(1);
      expect(tParam, isNotNull);
      final tNodeModel = await dataSource.create(tParam!);
      expect(expected, tNodeModel);
    });

    test('failed create', () async {
      // Arrange
      final node = Node((n) => n
        ..type = 1
        ..name = 'some name'
        ..parentId = 4);
      final tParam = NodeModel.fromNode(node);
      when(
        () => mockClient.post(
          any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ),
      ).thenThrow(UnauthorizedException());
      when(() => mockAuthenticationProvider.authenticationData).thenAnswer(
        (_) => tAuthData,
      );
      // act / assert
      expect(tParam, isNotNull);
      expect(() async => await dataSource.create(tParam!),
          throwsA(const TypeMatcher<UnauthorizedException>()),
          reason: 'unauthorized should propagate');
      verify(
        () => mockClient.post(
          any(),
          headers: {
            'Content-Type': 'Application/json',
            'Authentication': 'Bearer secret-token',
          },
          body: any(named: 'body'),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockClient);
    });

    test(
        'json serializing errors parsing the new node '
        'result in ApplicationException', () async {
      // Arrange
      final node = Node((n) => n
        ..type = 1
        ..name = 'some name'
        ..parentId = 4);
      final tParam = NodeModel.fromNode(node);
      when(() => mockClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer(
        (_) async => http.Response(
          fixture('node/post_result_parsing_error.json'),
          201,
        ),
      );
      when(() => mockAuthenticationProvider.authenticationData).thenAnswer(
        (_) => tAuthData,
      );
      expect(tParam, isNotNull);
      expect(() async => await dataSource.create(tParam!),
          throwsA(const TypeMatcher<ApplicationException>()),
          reason: 'response node is missing a name, serializing should throw '
              'exception that should be rethrown as an ApplicationException');
      verify(
        () => mockClient.post(
          any(),
          headers: {
            'Content-Type': 'Application/json',
            'Authentication': 'Bearer secret-token',
          },
          body: any(named: 'body'),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockClient);
    });

    test(
        'null json response should also result on '
        'result in ApplicationException', () async {
      // Arrange
      final node = Node((n) => n
        ..type = 1
        ..name = 'some name'
        ..parentId = 4);
      final tParam = NodeModel.fromNode(node);
      when(() => mockClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer(
        (_) async => http.Response(
          '',
          201,
        ),
      );
      when(() => mockAuthenticationProvider.authenticationData).thenAnswer(
        (_) => tAuthData,
      );
      expect(tParam, isNotNull);
      expect(() async => await dataSource.create(tParam!),
          throwsA(const TypeMatcher<ApplicationException>()),
          reason: 'response node is missing a name, serializing should throw '
              'exception that should be rethrown as an ApplicationException');
      verify(
        () => mockClient.post(
          any(),
          headers: {
            'Content-Type': 'Application/json',
            'Authentication': 'Bearer secret-token',
          },
          body: any(named: 'body'),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockClient);
    });
  });
}
