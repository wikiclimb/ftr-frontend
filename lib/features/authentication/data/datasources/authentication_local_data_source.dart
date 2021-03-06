import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exception.dart';
import '../models/authentication_data_model.dart';

/// Contracts to interact with data layer local access to authentication data.
abstract class AuthenticationLocalDataSource {
  static const String authCacheKey = 'WKC_CACHED_AUTHENTICATION_DATA';

  /// Gets the cached [AuthenticationDataModel].
  Future<AuthenticationDataModel?> getAuthenticationData();

  Future<bool> cacheAuthenticationData(AuthenticationDataModel authData);

  Future<bool> removeAuthenticationData();
}

/// Implementation of the [AuthenticationLocalDataSource] contracts.
class AuthenticationLocalDataSourceImpl
    implements AuthenticationLocalDataSource {
  AuthenticationLocalDataSourceImpl({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  @override
  Future<bool> cacheAuthenticationData(AuthenticationDataModel authData) {
    return sharedPreferences.setString(
      AuthenticationLocalDataSource.authCacheKey,
      jsonEncode(authData.toJson()),
    );
  }

  /// Fetch authentication data from the cache.
  ///
  /// Returns an [AuthenticationDataModel] if successful or null if
  /// it cannot find or convert data.
  /// Throws [CacheException] if problems are found.
  @override
  Future<AuthenticationDataModel?> getAuthenticationData() {
    late AuthenticationDataModel? model;
    try {
      final jsonString = sharedPreferences.getString(
        AuthenticationLocalDataSource.authCacheKey,
      );
      if (jsonString != null) {
        model = AuthenticationDataModel.fromJson(jsonDecode(jsonString));
      } else {
        model = null;
      }
    } catch (_) {
      throw const CacheException();
    }
    return Future.value(model);
  }

  @override
  Future<bool> removeAuthenticationData() {
    return sharedPreferences.remove(
      AuthenticationLocalDataSource.authCacheKey,
    );
  }
}
