import 'package:dartz/dartz.dart';

import '../../../../core/entities/response.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/password_recovery_params.dart';
import '../repositories/password_recovery_repository.dart';

/// Contract for requesting an email to recover a forgotten password.
class RequestPasswordRecoveryEmail
    extends UseCase<Response, PasswordRecoveryParams> {
  RequestPasswordRecoveryEmail(this.repository);

  final PasswordRecoveryRepository repository;

  @override
  Future<Either<Failure, Response>> call(params) async {
    return await repository.requestPasswordRecoveryEmail(params: params);
  }
}
