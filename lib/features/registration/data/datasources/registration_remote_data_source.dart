import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/entities/response.dart';
import '../../../../core/environment/environment_config.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/network/request_handler.dart';
import '../../domain/entities/sign_up_params.dart';

/// Contracts for the data layer of the registration feature.
abstract class RegistrationRemoteDataSource {
  /// Send registration data to the server.
  ///
  /// Returns `true` on success, which means that an inactive user was created
  /// and an email was sent with an activation link.
  Future<Response> register(SignUpParams params);

  /// Check wether a given username is available.
  ///
  /// Returns `true` if available, `false` otherwise.
  Future<bool> isUsernameAvailable(String username);
}

/// Implements [RegistrationRemoteDataSource]'s methods.
class RegistrationRemoteDataSourceImpl
    with RequestHandler
    implements RegistrationRemoteDataSource {
  RegistrationRemoteDataSourceImpl({required http.Client client})
      : _client = client;

  final http.Client _client;

  /// Sends a GET request to the server with a [String] as a parameter.
  /// The server responds `true` if the username is available and `false` if it
  /// is taken.
  @override
  Future<bool> isUsernameAvailable(String username) async {
    final uri = Uri.https(EnvironmentConfig.apiUrl, 'username-available');
    final response = await handleRequest(
      client: _client,
      uri: uri,
    );
    try {
      return jsonDecode(response.body);
    } catch (e) {
      throw ApplicationException(message: e.toString());
    }
  }

  /// Sends a POST request to the server with the parameters required to
  /// register a new user. If the registration is successful it returns `true`
  /// otherwise `false`.
  /// The user still needs to complete another step before they are able to
  /// use their account.
  @override
  Future<Response> register(SignUpParams params) async {
    final uri = Uri.https(EnvironmentConfig.apiUrl, 'sign-up');
    final response = await handleRequest(
      method: 'post',
      client: _client,
      uri: uri,
      body: params.toJson(),
      headers: {'Content-Type': 'application/json'},
    );
    try {
      return Response.fromJson(response.body)!;
    } catch (e) {
      throw const ApplicationException(message: 'Failed to serialize json');
    }
  }
}
