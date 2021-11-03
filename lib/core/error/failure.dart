// coverage:ignore-file
import 'package:equatable/equatable.dart';

/// Contract for failure classes.
abstract class Failure extends Equatable {
  const Failure([List properties = const <dynamic>[]]);
}

/// Generic server failure class.
///
/// Use this class to inform consumers that the system failed to get data
/// from a remote server.
class ServerFailure extends Failure {
  @override
  List<Object?> get props => [];
}

/// Generic cache failure class.
///
/// Use this class to inform consumers that the system failed to get data
/// from the local cache.
class CacheFailure extends Failure {
  @override
  List<Object?> get props => [];
}
