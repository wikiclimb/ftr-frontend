import 'package:dartz/dartz.dart';

import '../../../../core/entities/response.dart';
import '../../../../core/error/failure.dart';
import '../entities/password_recovery_params.dart';

/// Provides contracts to interact with password recovery data.
abstract class PasswordRecoveryRepository {
  /// Request a password recovery email to be sent to the given email.
  Future<Either<Failure, Response>> requestPasswordRecoveryEmail(
      {required PasswordRecoveryParams params});
}
