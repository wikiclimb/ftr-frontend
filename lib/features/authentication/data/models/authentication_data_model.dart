import '../../domain/entities/authentication_data.dart';

/// Data layer implementation of [AuthenticationData]
///
/// Handles low level functionality related to authentication data, like
/// converting to and from json.
class AuthenticationDataModel extends AuthenticationData {
  const AuthenticationDataModel({
    required String token,
    required int id,
    required String username,
  }) : super(token: token, id: id, username: username);

  factory AuthenticationDataModel.fromJson(Map<String, dynamic> json) {
    return AuthenticationDataModel(
      token: json['token'],
      id: json['id'],
      username: json['username'],
    );
  }

  factory AuthenticationDataModel.fromAuthenticationData(
      AuthenticationData authData) {
    return AuthenticationDataModel(
      token: authData.token,
      id: authData.id,
      username: authData.username,
    );
  }

  Map<String, dynamic> toJson() {
    return {'token': token, 'id': id, 'username': username};
  }
}
