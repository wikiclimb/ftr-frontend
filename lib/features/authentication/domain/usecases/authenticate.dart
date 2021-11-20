import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/authentication_data.dart';
import '../repositories/authentication_repository.dart';

/// Contracts to interact with authentication data.
///
/// This class should mainly be interacted with subscribing to the [Stream] but
/// a check can also be requested calling [checkAuthenticatedData].
class Authenticate {
  Authenticate(this.repository);

  final AuthenticationRepository repository;

  /// This method triggers an authentication check.
  void call() async {
    repository.checkAuthenticatedData();
  }

  /// Stream of authentication events, consumers should subscribe to this.
  Stream<Either<Failure, AuthenticationData>> get subscribe async* {
    yield* repository.authenticationData;
  }
}
