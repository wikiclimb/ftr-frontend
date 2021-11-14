part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

/// Notifies that we have an authenticated user with the given credentials.
class AuthenticationOk extends AuthenticationEvent {
  const AuthenticationOk(this.authenticationData);

  final AuthenticationData authenticationData;

  @override
  List<Object> get props => [authenticationData];
}

/// Notifies that we currently do not have an authenticated user.
class AuthenticationKo extends AuthenticationEvent {}

/// Launch a check of current authentication status.
class AuthenticationRequested extends AuthenticationEvent {}

/// The end user requests to logout.
class LogoutRequested extends AuthenticationEvent {}
