// coverage:ignore-file
import 'package:equatable/equatable.dart';

/// Contract for failure classes.
abstract class Failure extends Equatable {
  const Failure([List properties = const <dynamic>[]]);
}

/// Generic cache failure class.
///
/// Use this class to inform consumers that the system failed to get data
/// from the local cache.
class CacheFailure extends Failure {
  @override
  List<Object?> get props => [];
}

/// Generic server failure class.
///
/// Use this class to inform consumers that the system failed to get data
/// from a remote server.
class ServerFailure extends Failure {
  @override
  List<Object?> get props => [];
}

/// This failure informs us that we tried to perform an action and the
/// system determined we are not allowed to do so.
class UnauthorizedFailure extends Failure {
  @override
  List<Object?> get props => [];
}

/// This Failure represents not passing validation and can contain a
/// message that further explains the cause of failing validation.
class ValidationFailure extends Failure {
  const ValidationFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [];
}
