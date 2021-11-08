import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exception.dart';
import '../models/authentication_data_model.dart';

abstract class AuthenticationLocalDataSource {
  static const String authCacheKey = 'WKC_CACHED_AUTHENTICATION_DATA';

  /// Gets the cached [AuthenticationDataModel].
  ///
  /// Throws [NoLocalDataException] if there is no cached data.
  Future<AuthenticationDataModel> getAuthenticationData();

  Future<void> cacheAuthenticationData(AuthenticationDataModel authData);
}

class AuthenticationLocalDataSourceImpl
    implements AuthenticationLocalDataSource {
  AuthenticationLocalDataSourceImpl({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  @override
  Future<void> cacheAuthenticationData(AuthenticationDataModel authData) {
    return sharedPreferences.setString(
      AuthenticationLocalDataSource.authCacheKey,
      jsonEncode(authData.toJson()),
    );
  }

  @override
  Future<AuthenticationDataModel> getAuthenticationData() {
    final jsonString = sharedPreferences.getString(
      AuthenticationLocalDataSource.authCacheKey,
    );
    if (jsonString != null) {
      return Future.value(
          AuthenticationDataModel.fromJson(jsonDecode(jsonString)));
    }
    throw CacheException();
  }
}
