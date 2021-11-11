import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/authentication_data.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

abstract class AuthenticationRepository {
  // Future<Either<Failure, AuthenticationData>> getAuthenticationData();

  /// Trigger a check of the current authenticated status.
  ///
  /// This method triggers a check of the authenticated status that gets
  /// pushed to the stream controller for subscribers to receive.
  void checkAuthenticatedData();

  /// Stream of authentication status.
  Stream<Either<Failure, AuthenticationData>> get authenticationData;

  /// Clear up resources created by this repository.
  void dispose();

  /// Update the repository state to mark that a user has been authenticated.
  Future<bool> login(AuthenticationData authenticationData);

  /// Update the repository state to mark that the user has logged out.
  Future<bool> logout();
}
