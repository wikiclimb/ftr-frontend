part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationAuthenticated extends AuthenticationState {
  const AuthenticationAuthenticated(this.authenticationData);

  final AuthenticationData authenticationData;

  @override
  List<Object> get props => [authenticationData];
}

class AuthenticationUnauthenticated extends AuthenticationState {}
