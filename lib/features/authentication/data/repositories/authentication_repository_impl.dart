import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/authentication_data.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../datasources/authentication_local_data_source.dart';
import '../models/authentication_data_model.dart';

/// Implementation of the [AuthenticationRepository] contract.
class AuthenticationRepositoryImpl implements AuthenticationRepository {
  AuthenticationRepositoryImpl({
    required this.localDataSource,
  });

  final AuthenticationLocalDataSource localDataSource;

  final _controller = StreamController<Either<Failure, AuthenticationData>>();

  @override
  void dispose() {
    _controller.close();
  }

  @override
  Future<void> checkAuthenticatedData() async {
    try {
      final authenticationData = await localDataSource.getAuthenticationData();
      if (authenticationData != null) {
        _controller.add(Right(authenticationData));
      }
    } catch (_) {}
  }

  /// Subscription to authentication state changes.
  @override
  Stream<Either<Failure, AuthenticationData>> get authenticationData async* {
    try {
      final result = await localDataSource.getAuthenticationData();
      if (result != null) {
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
