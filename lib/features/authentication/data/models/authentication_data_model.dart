import 'package:wikiclimb_flutter_frontend/features/authentication/domain/entities/authentication_data.dart';

class AuthenticationDataModel extends AuthenticationData {
  const AuthenticationDataModel({required String token, required int id})
      : super(token: token, id: id);

  factory AuthenticationDataModel.fromJson(Map<String, dynamic> json) {
    return AuthenticationDataModel(token: json['token'], id: json['id']);
  }

  Map<String, dynamic> toJson() {
    return {'token': token, 'id': id};
  }
}
