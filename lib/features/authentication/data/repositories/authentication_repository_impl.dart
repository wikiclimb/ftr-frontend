import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../core/authentication/authentication_provider.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/authentication_data.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../datasources/authentication_local_data_source.dart';
import '../models/authentication_data_model.dart';

/// Implementation of the [AuthenticationRepository] contracts.
class AuthenticationRepositoryImpl implements AuthenticationRepository {
  AuthenticationRepositoryImpl({
    required this.localDataSource,
    required this.authenticationProvider,
  });

  final AuthenticationLocalDataSource localDataSource;
  final AuthenticationProvider authenticationProvider;

  final _controller = StreamController<Either<Failure, AuthenticationData>>();

  @override
  void dispose() {
    _controller.close();
  }

  @override
  Future<AuthenticationData?> checkAuthenticatedData() async {
    try {
      final authenticationData = await localDataSource.getAuthenticationData();
      if (authenticationData != null) {
        authenticationProvider.cacheAuthenticationData(authenticationData);
        _controller.add(Right(authenticationData));
        return authenticationData;
      }
      throw AuthenticationFailure();
    } catch (e) {
      _controller.add(Left(AuthenticationFailure()));
    }
  }

  /// Subscription to authentication state changes.
  @override
  Stream<Either<Failure, AuthenticationData>> get authenticationData async* {
    try {
      final result = await localDataSource.getAuthenticationData();
      if (result != null) {
        authenticationProvider.cacheAuthenticationData(result);
        yield Right(result);
      } else {
        yield Left(AuthenticationFailure());
      }
    } catch (_) {
      yield Left(CacheFailure());
    }
    yield* _controller.stream;
  }

  @override
  Future<bool> login(AuthenticationData authenticationData) async {
    try {
      final result = await localDataSource.cacheAuthenticationData(
        AuthenticationDataModel.fromAuthenticationData(authenticationData),
      );
      if (result) {
        authenticationProvider.cacheAuthenticationData(authenticationData);
        _controller.add(Right(authenticationData));
      }
      return result;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> logout() async {
    try {
      final result = await localDataSource.removeAuthenticationData();
      if (result) {
        authenticationProvider.removeAuthenticationData();
        _controller.add(
          Left(AuthenticationFailure()),
        );
      }
      return result;
    } catch (_) {
      return false;
    }
  }
}
