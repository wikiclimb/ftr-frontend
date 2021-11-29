import 'package:equatable/equatable.dart';

/// General catch-all exception type, try to use a more concrete class.
class ApplicationException extends Equatable implements Exception {
  const ApplicationException({String? message}) : _message = message;

  final String? _message;

  @override
  List<Object?> get props => [_message];

  String? get message => _message;
}

/// There was an error recovering local data.
class CacheException extends ApplicationException {
  const CacheException({String? message}) : super(message: message);
}

/// There was an error on the network.
class NetworkException extends ApplicationException {
  const NetworkException({String? message}) : super(message: message);
}

/// There was an error on the server.
class ServerException extends ApplicationException {
  const ServerException({String? message}) : super(message: message);
}

/// You need to authenticate to do that operation.
class UnauthorizedException extends ApplicationException {
  const UnauthorizedException({String? message}) : super(message: message);
}

/// The current user is not allowed to do that operation.
class ForbiddenException extends ApplicationException {
  const ForbiddenException({String? message}) : super(message: message);
}
