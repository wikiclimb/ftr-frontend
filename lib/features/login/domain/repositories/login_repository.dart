import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../authentication/domain/entities/authentication_data.dart';

/// Provides contracts to interact with the login data.
abstract class LoginRepository {
  /// Login a user using their username and password.
  ///
  /// This function updates the global authentication status if successful.
  Future<Either<Failure, AuthenticationData>> logInWithUsernamePassword(
      {required String username, required String password});
}
