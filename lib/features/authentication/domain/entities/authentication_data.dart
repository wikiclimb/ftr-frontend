import 'package:equatable/equatable.dart';

class AuthenticationData extends Equatable {
  const AuthenticationData({
    required this.token,
    required this.id,
    required this.username,
  });

  final int id;
  final String token;
  final String username;

  @override
  List<Object?> get props => [id];
}
