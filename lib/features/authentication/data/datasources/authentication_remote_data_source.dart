import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wikiclimb_flutter_frontend/core/environment/environment_config.dart';
import 'package:wikiclimb_flutter_frontend/core/error/exception.dart';

import '../models/authentication_data_model.dart';

abstract class AuthenticationRemoteDataSource {
  /// Calls the https://apiv1.wikipedia.org/login endpoint
  ///
  /// Throws a [ServerException] for all error codes.
  Future<AuthenticationDataModel> login(
      {required String username, required String password});
}

class AuthenticationRemoteDataSourceImpl
    implements AuthenticationRemoteDataSource {
  AuthenticationRemoteDataSourceImpl({required this.client});

  final http.Client client;

  @override
  Future<AuthenticationDataModel> login(
      {required String username, required String password}) async {
    final url = Uri.https(
      EnvironmentConfig.apiUrl,
      'login',
    );
    final response = await client.post(
      url,
      body: {'username': username, 'password': password},
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return AuthenticationDataModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException();
    }
  }
}
