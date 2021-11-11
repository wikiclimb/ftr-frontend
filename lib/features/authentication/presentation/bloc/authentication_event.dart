part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationOk extends AuthenticationEvent {
  const AuthenticationOk(this.authenticationData);

  final AuthenticationData authenticationData;

  @override
  List<Object> get props => [authenticationData];
}

class AuthenticationKo extends AuthenticationEvent {}

class AuthenticationRequested extends AuthenticationEvent {}
