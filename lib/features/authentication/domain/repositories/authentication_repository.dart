import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/authentication_data.dart';

abstract class AuthenticationRepository {
  Future<Either<Failure, AuthenticationData>> getAuthenticationData();
}
