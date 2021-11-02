import 'package:equatable/equatable.dart';

class AuthenticationData extends Equatable {
  const AuthenticationData({required this.token, required this.id});

  final int id;
  final String token;

  // coverage:ignore-start
  @override
  List<Object?> get props => [id, token];
  // coverage:ignore-end
}
