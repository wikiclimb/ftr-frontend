import 'package:dartz/dartz.dart';

import '../../../../core/entities/response.dart';
import '../../../../core/error/failure.dart';
import '../entities/sign_up_params.dart';

/// Provides contracts to interact with the registration data layer.
abstract class RegistrationRepository {
  /// Create a new user given the email, username and password.
  Future<Either<Failure, Response>> signUpWithEmailPassword(
      SignUpParams params);

  /// Check if a given username is available.
  ///
  /// This method returns true if the username is available false otherwise.
  Future<Either<Failure, bool>> isUsernameAvailable(String username);
}
