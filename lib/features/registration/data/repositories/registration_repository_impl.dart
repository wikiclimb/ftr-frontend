import 'package:dartz/dartz.dart';

import '../../../../core/entities/response.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/sign_up_params.dart';
import '../../domain/repositories/registration_repository.dart';
import '../datasources/registration_remote_data_source.dart';

/// Provides implementations for the contracts on [RegistrationRepository].
class RegistrationRepositoryImpl
    with ExceptionHandler
    implements RegistrationRepository {
  RegistrationRepositoryImpl(this.remoteDataSource);

  final RegistrationRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, bool>> isUsernameAvailable(String username) async {
    try {
      return Right(await remoteDataSource.isUsernameAvailable(username));
    } on Exception catch (e) {
      return Left(exceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Response>> signUpWithEmailPassword(
      SignUpParams params) async {
    try {
      return Right(await remoteDataSource.register(params));
    } on Exception catch (e) {
      return Left(exceptionToFailure(e));
    }
  }
}
