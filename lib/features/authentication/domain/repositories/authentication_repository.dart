import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/authentication_data.dart';

/// Contract class for authentication use cases.
abstract class AuthenticationRepository {
  Future<Either<Failure, AuthenticationData>> signUpWithEmailPassword(
      {required String email, required String password});
}
