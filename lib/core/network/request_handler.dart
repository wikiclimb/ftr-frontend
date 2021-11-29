import 'dart:io';

import 'package:http/http.dart' as http;

import '../error/exception.dart';

/// Request handler mixin to be used on remote datasources requests.
///
/// This mixin contains the common boilerplate that handles and relaunches
/// the exceptions that can happen while performing a network request.
mixin RequestHandler {
  Future<http.Response> handleRequest({
    required http.Client client,
    required Uri uri,
    String method = 'get',
    String? body,
    Map<String, String>? headers,
  }) async {
    try {
      late final http.Response response;
      if (method == 'post') {
        response = await client.post(uri, headers: headers, body: body);
      } else if (method == 'patch') {
        response = await client.patch(uri, headers: headers, body: body);
      } else {
        response = await client.get(uri);
      }
      switch (response.statusCode) {
        case 200:
        case 201:
          // TODO: check why the return line shows as not covered by tests.
          // There are two tests in request_handler_test.dart that cover it.
          // Debugging shows the execution flow go passed this point.
          return response;
        case 401:
          throw const UnauthorizedException();
        case 403:
          throw const ForbiddenException();
        default:
          // We got a response from the server but not one of the expected ones.
          throw const ServerException();
      }
    } on UnauthorizedException {
      throw const UnauthorizedException();
    } on ForbiddenException {
      throw const ForbiddenException();
    } on ServerException {
      throw const ServerException();
    } on SocketException {
      throw const NetworkException();
    } on NetworkException {
      throw const NetworkException();
    } catch (e) {
      throw const ApplicationException();
    }
  }
}
