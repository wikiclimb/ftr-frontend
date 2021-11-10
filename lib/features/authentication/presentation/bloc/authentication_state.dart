part of 'authentication_cubit.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationFailed extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationSuccess extends AuthenticationState {
  const AuthenticationSuccess(this.authenticationData);

  final AuthenticationData authenticationData;

  @override
  List<Object> get props => [authenticationData];
}
