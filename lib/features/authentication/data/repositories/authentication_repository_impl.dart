import '../../../../core/error/exception.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/authentication_local_data_source.dart';
import '../datasources/authentication_remote_data_source.dart';
import '../../domain/entities/authentication_data.dart';
import '../../../../core/error/failure.dart';
import 'package:dartz/dartz.dart';
import '../../domain/repositories/authentication_repository.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthenticationRemoteDataSource remoteDataSource;
  final AuthenticationLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthenticationRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, AuthenticationData>> logInWithUsernamePassword(
      {required String username, required String password}) async {
    networkInfo.isConnected;
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
    }
  }

  @override
  Future<Either<Failure, AuthenticationData>> getAuthenticationData() async {
    try {
      return Right(await localDataSource.getAuthenticationData());
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
