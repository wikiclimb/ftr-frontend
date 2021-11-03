import '../models/authentication_data_model.dart';

abstract class AuthenticationRemoteDataSource {
  /// Calls the https://apiv1.wikipedia.org/login endpoint
  ///
  /// Throws a [ServerException] for all error codes.
  Future<AuthenticationDataModel> login(
      {required String username, required String password});
}
