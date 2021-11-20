import '../../features/authentication/domain/entities/authentication_data.dart';

/// A simple [Provider] for [AuthenticationData] that can be injected.
abstract class AuthenticationProvider {
  /// Returns the cached [AuthenticationData] model if found.
  ///
  /// If not cached [AuthenticationData] is found in the instance, it does not
  /// try to read it from storage. This method relies on the authentication
  /// data having been retrieved before it is called.
  AuthenticationData? get authenticationData;

  /// Save an instance of [AuthenticationData] as this instance's data.
  void cacheAuthenticationData(AuthenticationData authenticationData);

  /// Remove any authentication data that this may have.
  void removeAuthenticationData();
}

class AuthenticationProviderImpl implements AuthenticationProvider {
  // Store in memory.
  AuthenticationData? _authenticationData;

  @override
  AuthenticationData? get authenticationData => _authenticationData;

  @override
  void cacheAuthenticationData(AuthenticationData authenticationData) {
    _authenticationData = authenticationData;
  }

  @override
  void removeAuthenticationData() {
    _authenticationData = null;
  }
}
