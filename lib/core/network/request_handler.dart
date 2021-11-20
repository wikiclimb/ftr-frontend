import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:wikiclimb_flutter_frontend/core/error/exception.dart';

/// Request handler mixin to be used on remote datasources requests.
///
/// This mixin contains the common boilerplate that handles and relaunches
/// the exceptions that can happen while performing a network request.
mixin RequestHandler {
  Future<http.Response> handleRequest({
    required http.Client client,
    required Uri uri,
    String method = 'get',
  }) async {
    try {
      final response = await client.get(uri);
      switch (response.statusCode) {
        case 200:
          return response;
        case 401:
          throw UnauthorizedException();
        case 403:
          throw ForbiddenException();
        default:
          // We got a response from the server but not one of the expected ones.
          throw ServerException();
      }
    } on UnauthorizedException {
      throw UnauthorizedException();
    } on ForbiddenException {
      throw ForbiddenException();
    } on ServerException {
      throw ServerException();
    } on SocketException {
      throw NetworkException();
    } catch (e) {
      throw ApplicationException();
    }
  }
}
