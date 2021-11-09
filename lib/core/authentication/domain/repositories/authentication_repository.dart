import 'package:dartz/dartz.dart';

import '../entities/authentication_data.dart';
import '../../../error/failure.dart';

abstract class AuthenticationRepository {
  Future<Either<Failure, AuthenticationData>> getAuthenticationData();
}
