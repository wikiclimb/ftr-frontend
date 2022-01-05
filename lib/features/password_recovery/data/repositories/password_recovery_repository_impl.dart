import 'package:dartz/dartz.dart';

import '../../../../core/entities/response.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/password_recovery_params.dart';
import '../../domain/repositories/password_recovery_repository.dart';
import '../datasources/password_recovery_remote_data_source.dart';

/// Implementations for the contracts in [PasswordRecoveryRepository].
class PasswordRecoveryRepositoryImpl
    with ExceptionHandler
    implements PasswordRecoveryRepository {
  PasswordRecoveryRepositoryImpl(this.remoteDataSource);

  final PasswordRecoveryRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, Response>> requestPasswordRecoveryEmail(
      {required PasswordRecoveryParams params}) async {
    try {
      return Right(await remoteDataSource.requestPasswordRecoveryEmail(params));
    } on Exception catch (e) {
      return Left(exceptionToFailure(e));
    }
  }
}
