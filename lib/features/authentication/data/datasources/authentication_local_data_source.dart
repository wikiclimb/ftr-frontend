import '../models/authentication_data_model.dart';

abstract class AuthenticationLocalDataSource {
  /// Gets the cached [AuthenticationDataModel].
  ///
  /// Throws [NoLocalDataException] if there is no cached data.
  Future<AuthenticationDataModel> getAuthenticationData();

  Future<void> cacheAuthenticationData(AuthenticationDataModel authData);
}
