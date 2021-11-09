import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../authentication/domain/entities/authentication_data.dart';

/// Contract class for login use cases.
abstract class LoginRepository {
  Future<Either<Failure, AuthenticationData>> logInWithUsernamePassword(
      {required String username, required String password});
}
