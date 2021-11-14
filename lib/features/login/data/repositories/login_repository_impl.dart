import 'package:dartz/dartz.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/error/failure.dart';
import '../../../authentication/domain/entities/authentication_data.dart';
import '../../../authentication/domain/repositories/authentication_repository.dart';
import '../../domain/repositories/login_repository.dart';
import '../datasources/login_remote_data_source.dart';

/// Implementation of the [LoginRepository] contract.
class LoginRepositoryImpl implements LoginRepository {
  LoginRepositoryImpl({
    required LoginRemoteDataSource remoteDataSource,
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        _remoteDataSource = remoteDataSource;

  final AuthenticationRepository _authenticationRepository;
  final LoginRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, AuthenticationData>> logInWithUsernamePassword(
      {required String username, required String password}) async {
    try {
      final authData = await _remoteDataSource.login(
        username: username,
        password: password,
      );
      final cached = await _authenticationRepository.login(authData);
      if (cached) {
        return Right(authData);
      } else {
        throw CacheException();
      }
    } on UnauthorizedException {
      return Left(UnauthorizedFailure());
    } on ServerException {
      return Left(ServerFailure());
    } on NetworkException {
      return Left(NetworkFailure());
    } on CacheException {
      return Left(CacheFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
