import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/environment/environment_config.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/network/network_info.dart';
import '../../../authentication/data/models/authentication_data_model.dart';

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
  LoginRemoteDataSourceImpl({
    required this.client,
    required this.networkInfo,
  });

  final http.Client client;
  final NetworkInfo networkInfo;

  @override
  Future<AuthenticationDataModel> login(
      {required String username, required String password}) async {
    final url = Uri.https(
      EnvironmentConfig.apiUrl,
      'login',
    );
    // final url = Uri.parse('${EnvironmentConfig.apiUrl}/login');
    try {
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        throw const NetworkException();
      }
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
          throw const UnauthorizedException();
        default:
          // We got a response from the server but not one of the expected ones.
          throw const ServerException();
      }
    } on UnauthorizedException {
      throw const UnauthorizedException();
    } on ServerException {
      throw const ServerException();
    } catch (e) {
      // We could not reach the server.
      throw const NetworkException();
    }
  }
}
