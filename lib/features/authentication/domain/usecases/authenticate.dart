import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/authentication_data.dart';
import '../repositories/authentication_repository.dart';

class Authenticate {
  Authenticate(this.repository);

  final AuthenticationRepository repository;

  /// This method triggers an authentication check.
  void call() {
    repository.checkAuthenticatedData();
  }

  /// Stream of authentication events, consumers should subscribe to this.
  Stream<Either<Failure, AuthenticationData>> get subscribe async* {
    yield* repository.authenticationData;
  }
}
