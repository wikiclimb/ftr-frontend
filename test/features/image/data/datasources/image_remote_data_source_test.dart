// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:built_collection/built_collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import 'package:wikiclimb_flutter_frontend/core/authentication/authentication_provider.dart';
import 'package:wikiclimb_flutter_frontend/core/error/exception.dart';
import 'package:wikiclimb_flutter_frontend/features/image/data/datasources/image_remote_data_source.dart';
import 'package:wikiclimb_flutter_frontend/features/image/domain/usecases/add_images_to_node.dart';

import '../../../../fixtures/fixture_reader.dart';
import '../../../../fixtures/headers/links.dart';
import '../../../../fixtures/image/create_multiple_201_parsed.dart';
import '../../../../fixtures/image/image_model_pages.dart';

class MockClient extends Mock implements http.Client {}

class MockMultipartRequest extends Mock implements http.MultipartRequest {}

class MockStreamedResponse extends Mock implements http.StreamedResponse {}

class MockAuthenticationProvider extends Mock
    implements AuthenticationProvider {}

class FakeUri extends Fake implements Uri {}

void main() {
  late ImageRemoteDataSource dataSource;
  late MockClient mockClient;
  late AuthenticationProvider mockAuthenticationProvider;

  setUpAll(() {
    registerFallbackValue(FakeUri());
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

  group('create', () {
    final tPaths = ['test/fixtures/image/fetch-all-200.json'];
    final tParams = Params(
      filePaths: tPaths,
      nodeId: 1,
      name: 'name',
      description: 'description',
    );
    final fileData = File('test/fixtures/image/create-multiple-201.json');
    final bytes = fileData.readAsBytes();
    final Map<String, String> fields = {};
    final List<http.MultipartFile> files = [];
    final Map<String, String> headers = {};
    late http.MultipartRequest mockMultipartRequest;
    late http.StreamedResponse mockStreamedResponse;
    late GetIt sl;

    setUpAll(() {
      mockMultipartRequest = MockMultipartRequest();
      mockStreamedResponse = MockStreamedResponse();
      when(() => mockMultipartRequest.fields).thenAnswer((_) => fields);
      when(() => mockMultipartRequest.headers).thenAnswer((_) => headers);
      when(() => mockMultipartRequest.files).thenAnswer((_) => files);
      when(() => mockStreamedResponse.isRedirect).thenAnswer((_) => false);
      when(() => mockStreamedResponse.persistentConnection)
          .thenAnswer((_) => false);
      when(() => mockStreamedResponse.headers).thenAnswer((_) => headers);
      when(() => mockStreamedResponse.stream)
          .thenAnswer((_) => http.ByteStream(Stream.fromFuture(bytes)));
      when(() => mockMultipartRequest.send())
          .thenAnswer((_) async => mockStreamedResponse);
      // Mock the MultipartRequest
      sl = GetIt.instance;
      sl.registerFactoryParam<http.MultipartRequest, void, void>(
          (_, __) => mockMultipartRequest);
    });

    test('success', () async {
      when(() => mockStreamedResponse.statusCode).thenAnswer((_) => 201);
      final result = await dataSource.create(tParams);
      expect(result, BuiltList(createMultiple201ResponseImageModels));
    });

    test('Unauthorized exception', () async {
      when(() => mockStreamedResponse.statusCode).thenAnswer((_) => 401);
      expect(
        () => dataSource.create(tParams),
        throwsA(TypeMatcher<UnauthorizedException>()),
      );
    });

    test('Forbidden exception', () async {
      when(() => mockStreamedResponse.statusCode).thenAnswer((_) => 403);
      expect(
        () => dataSource.create(tParams),
        throwsA(TypeMatcher<ForbiddenException>()),
      );
    });

    test('other exceptions', () async {
      when(() => mockStreamedResponse.statusCode).thenAnswer((_) => 500);
      expect(
        () => dataSource.create(tParams),
        throwsA(TypeMatcher<ApplicationException>()),
      );
    });

    test('connection fails', () async {
      when(() => mockStreamedResponse.statusCode).thenAnswer(
        (_) => throw SocketException('timed out'),
      );
      expect(
        () => dataSource.create(tParams),
        throwsA(TypeMatcher<ApplicationException>()),
      );
    });

    test('badly formatted json', () async {
      final badlyFormattedFileData =
          File('test/fixtures/image/fetch-all-200-json-serialize-error.json');
      final errorBytes = badlyFormattedFileData.readAsBytes();
      when(() => mockStreamedResponse.stream)
          .thenAnswer((_) => http.ByteStream(Stream.fromFuture(errorBytes)));
      when(() => mockStreamedResponse.statusCode).thenAnswer((_) => 201);
      expect(
        () async => await dataSource.create(tParams),
        throwsA(TypeMatcher<ApplicationException>()),
      );
    });
  });
}
