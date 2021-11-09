import 'package:dartz/dartz.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/authentication_data.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../datasources/authentication_local_data_source.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  AuthenticationRepositoryImpl({
    required this.localDataSource,
  });

  final AuthenticationLocalDataSource localDataSource;

  @override
  Future<Either<Failure, AuthenticationData>> getAuthenticationData() async {
    try {
      return Right(await localDataSource.getAuthenticationData());
    } on CacheException {
      return Left(AuthenticationFailure());
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
