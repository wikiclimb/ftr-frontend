import 'package:flutter_test/flutter_test.dart';

import 'package:wikiclimb_flutter_frontend/core/authentication/authentication_provider.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/entities/authentication_data.dart';

void main() {
  const tAuthData = AuthenticationData(
    token: 'token',
    id: 12,
    username: 'test-user-name',
  );
  test('should save and return data if cached', () {
    final authProvider = AuthenticationProviderImpl();
    authProvider.cacheAuthenticationData(tAuthData);
    expect(authProvider.authenticationData, tAuthData);
  });

  test('should return null when not set', () {
    final authProvider = AuthenticationProviderImpl();
    expect(authProvider.authenticationData, null);
  });

  test('should save and return data if cached', () {
    final authProvider = AuthenticationProviderImpl();
    authProvider.cacheAuthenticationData(tAuthData);
    expect(authProvider.authenticationData, tAuthData);
    authProvider.removeAuthenticationData();
    expect(authProvider.authenticationData, null);
  });
}
