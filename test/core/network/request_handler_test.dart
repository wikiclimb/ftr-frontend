import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import 'package:wikiclimb_flutter_frontend/core/network/request_handler.dart';

class MockClient extends Mock implements http.Client {}

class FakeUri extends Fake implements Uri {}

void main() {
  late FakeClass fake;
  late MockClient mockClient;

  setUpAll(() {
    registerFallbackValue(FakeUri());
  });

  setUp(() {
    mockClient = MockClient();
    fake = FakeClass();
  });

  test('mixin returns response when 200', () async {
    final tResponse = http.Response(
      'body',
      200,
    );
    when(() => mockClient.get(any()))
        .thenAnswer((invocation) async => tResponse);
    final response = await fake.handleRequest(
      client: mockClient,
      uri: FakeUri(),
    );
    expect(response, tResponse);
  });

  test('get returns response when 200', () async {
    final tResponse = http.Response(
      'body',
      200,
    );
    when(() => mockClient.get(any()))
        .thenAnswer((invocation) async => tResponse);
    final response = await fake.request(client: mockClient, uri: FakeUri());
    expect(response, tResponse);
  });

  test('post returns response when 201', () async {
    final tResponse = http.Response(
      '{"one": "uno", "two": "dos"}',
      201,
    );
    when(() => mockClient.post(
          any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        )).thenAnswer(
      (_) async => tResponse,
    );
    final response = await fake.handleRequest(
      client: mockClient,
      uri: FakeUri(),
      method: 'post',
      body: {'one': 'uno', 'two': 'dos'},
    );
    expect(response, tResponse);
  });
}

class FakeClass with RequestHandler {
  Future<http.Response> request({
    required http.Client client,
    required Uri uri,
    String method = 'get',
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    return await handleRequest(
      client: client,
      uri: uri,
      method: method,
      body: body,
      headers: headers,
    );
  }
}
