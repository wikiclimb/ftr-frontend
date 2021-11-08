import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/authentication/domain/entities/authentication_data.dart';

/// Contract class for authentication use cases.
abstract class LoginRepository {
  Future<Either<Failure, AuthenticationData>> logInWithUsernamePassword(
      {required String username, required String password});

  Future<Either<Failure, AuthenticationData>> getAuthenticationData();
}
