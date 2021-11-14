import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wikiclimb_flutter_frontend/core/error/exception.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/data/datasources/authentication_local_data_source.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/data/models/authentication_data_model.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'authentication_local_data_source_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late AuthenticationLocalDataSource dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = AuthenticationLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group('getCachedAuthenticationData', () {
    final tAuthenticationDataModel = AuthenticationDataModel.fromJson(
        json.decode(fixture('authentication/cached_auth_data.json')));

    test(
      'should return AuthenticationData from SharedPreferences '
      'when there is data in the cache',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('authentication/cached_auth_data.json'));
        // act
        final result = await dataSource.getAuthenticationData();
        // assert
        verify(mockSharedPreferences
            .getString(AuthenticationLocalDataSource.authCacheKey));
        expect(result, equals(tAuthenticationDataModel));
      },
    );

    test('should throw a CacheException when there is not a cached value', () {
      // arrange
      when(mockSharedPreferences.getString(any)).thenThrow(Exception());
      // act
      // Not calling the method here, just storing it inside a call variable
      final call = dataSource.getAuthenticationData;
      // assert
      // Calling the method happens from a higher-order function passed.
      // This is needed to test if calling a method throws an exception.
      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });

    test(
      'should throw a CacheException when there is not a cached value',
      () async {
        when(mockSharedPreferences.getString(any)).thenReturn(null);
        final result = await dataSource.getAuthenticationData();
        expect(result, null);
      },
    );
  });

  group('cacheAuthenticationData', () {
    const tAuthenticationDataModel = AuthenticationDataModel(
      token: 'test-token',
      id: 753,
      username: 'test-username',
    );

    test('should call SharedPreferences', () async {
      final expectedJsonString = jsonEncode(tAuthenticationDataModel.toJson());
      when(mockSharedPreferences.setString(
        AuthenticationLocalDataSource.authCacheKey,
        expectedJsonString,
      )).thenAnswer((realInvocation) async => true);
      await dataSource.cacheAuthenticationData(tAuthenticationDataModel);
      verify(mockSharedPreferences.setString(
        AuthenticationLocalDataSource.authCacheKey,
        expectedJsonString,
      ));
    });
  });

  group('remove authentication data', () {
    test('remove successful', () async {
      when(mockSharedPreferences.remove(any)).thenAnswer((_) async => true);

      final result = await dataSource.removeAuthenticationData();
      expect(result, true);
      verify(mockSharedPreferences.remove(any)).called(1);
      verifyNoMoreInteractions(mockSharedPreferences);
    });

    test('remove failed', () async {
      when(mockSharedPreferences.remove(any)).thenAnswer((_) async => false);

      final result = await dataSource.removeAuthenticationData();
      expect(result, false);
      verify(mockSharedPreferences.remove(any)).called(1);
      verifyNoMoreInteractions(mockSharedPreferences);
    });
  });
}
