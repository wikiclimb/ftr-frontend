import 'package:dartz/dartz.dart';
import 'package:wikiclimb_flutter_frontend/core/error/failures.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/entities/authentication_data.dart';

import '../repositories/authentication_repository.dart';

class SignUpWithEmailPassword {
  SignUpWithEmailPassword(this.repository);

  final AuthenticationRepository repository;

  Future<Either<Failure, AuthenticationData>> execute(
      {required String email, required String password}) async {
    return await repository.signUpWithEmailPassword(
        email: email, password: password);
  }
}
