import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/entities/response.dart';
import '../../../../core/environment/environment_config.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/network/request_handler.dart';
import '../../domain/entities/password_recovery_params.dart';

/// Contracts for the password recovery data layer.
abstract class PasswordRecoveryRemoteDataSource {
  Future<Response> requestPasswordRecoveryEmail(PasswordRecoveryParams params);
}

/// Implement [PasswordRecoveryRemoteDataSource]'s contracts.
class PasswordRecoveryRemoteDataSourceImpl
    with RequestHandler
    implements PasswordRecoveryRemoteDataSource {
  PasswordRecoveryRemoteDataSourceImpl({required http.Client client})
      : _client = client;

  final http.Client _client;

  @override
  Future<Response> requestPasswordRecoveryEmail(
      PasswordRecoveryParams params) async {
    final uri = Uri.https(EnvironmentConfig.apiUrl, 'password-recovery');
    final response = await handleRequest(
      method: 'post',
      client: _client,
      uri: uri,
      body: json.encode(params.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    try {
      return Response.fromJson(response.body)!;
    } catch (e) {
      throw const ApplicationException(message: 'Failed to serialize json');
    }
  }
}
