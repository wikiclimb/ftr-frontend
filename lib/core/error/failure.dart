// coverage:ignore-file
import 'package:equatable/equatable.dart';

/// Contract for failure classes.
abstract class Failure extends Equatable {
  const Failure([List properties = const <dynamic>[]]);

  @override
  List<Object?> get props => [];
}

/// This failure tells us that an unexpected situation ocurred. The application
/// logic has a problem that we need to manually find and correct.
/// This is a catch all [Failure], in general is better to use a concrete one.
class ApplicationFailure extends Failure {}

/// This failure communicates that authentication data was not found.
class AuthenticationFailure extends Failure {}

/// Generic cache failure class.
///
/// Use this class to inform consumers that the system failed to get data
/// from the local cache.
class CacheFailure extends Failure {}

/// Generic network failure class.
///
/// Use this class to inform consumers that the system failed to connect to
/// a remote server.
class NetworkFailure extends Failure {}

/// Generic server failure class.
///
/// Use this class to inform consumers that the system failed to get data
/// from a remote server.
class ServerFailure extends Failure {}

/// This failure informs us that we tried to perform an action and the
/// system determined we are not allowed to do so.
class UnauthorizedFailure extends Failure {}

/// This failure informs the user that we tried to perform an action for which
/// the currently authenticated user does not have permission.
class ForbiddenFailure extends Failure {}

/// This Failure represents not passing validation and can contain a
/// message that further explains the cause of failing validation.
class ValidationFailure extends Failure {
  const ValidationFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
