import 'package:dartz/dartz.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/error/failure.dart';
import '../../../authentication/data/datasources/authentication_local_data_source.dart';
import '../../../authentication/domain/entities/authentication_data.dart';
import '../../domain/repositories/login_repository.dart';
import '../datasources/login_remote_data_source.dart';

class LoginRepositoryImpl implements LoginRepository {
  LoginRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final AuthenticationLocalDataSource localDataSource;
  final LoginRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, AuthenticationData>> logInWithUsernamePassword(
      {required String username, required String password}) async {
    try {
      final authData = await remoteDataSource.login(
        username: username,
        password: password,
      );
      localDataSource.cacheAuthenticationData(authData);
      return Right(authData);
    } on UnauthorizedException {
      return Left(UnauthorizedFailure());
    } on ServerException {
      return Left(ServerFailure());
    } on NetworkException {
      return Left(NetworkFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
