part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginRequested extends LoginEvent {
  final String username;
  final String password;

  const LoginRequested({required this.username, required this.password});
  // coverage:ignore-start
  @override
  List<Object> get props => [username, password];
  // coverage:ignore-end
}
