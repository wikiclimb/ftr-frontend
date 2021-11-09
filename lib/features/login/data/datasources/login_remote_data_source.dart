import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../../authentication/data/models/authentication_data_model.dart';

import '../../../../core/environment/environment_config.dart';
import '../../../../core/error/exception.dart';

abstract class LoginRemoteDataSource {
  /// Calls the login endpoint
  ///
  /// Throws a [ServerException] for server response codes.
  /// Throws a [NetworkException] for network errors.
  /// Throws an [UnauthorizedException] for failed login attempts.
  Future<AuthenticationDataModel> login(
      {required String username, required String password});
}

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  LoginRemoteDataSourceImpl({required this.client});

  final http.Client client;

  @override
  Future<AuthenticationDataModel> login(
      {required String username, required String password}) async {
    final url = Uri.https(
      EnvironmentConfig.apiUrl,
      'login',
    );
    try {
      final response = await client.post(
        url,
        body: jsonEncode({'username': username, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );
      switch (response.statusCode) {
        case 200:
          return AuthenticationDataModel.fromJson(
            jsonDecode(response.body),
          );
        case 401:
          throw UnauthorizedException();
        default:
          // We got a response from the server but not one of the expected ones.
          throw ServerException();
      }
    } on UnauthorizedException {
      throw UnauthorizedException();
    } on ServerException {
      throw ServerException();
    } catch (e) {
      // We could not reach the server.
      throw NetworkException();
    }
  }
}
