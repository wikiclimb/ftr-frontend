import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:wikiclimb_flutter_frontend/core/authentication/authentication_provider.dart';
import 'package:wikiclimb_flutter_frontend/core/error/exception.dart';
import 'package:wikiclimb_flutter_frontend/core/error/failure.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/data/datasources/authentication_local_data_source.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/data/models/authentication_data_model.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/entities/authentication_data.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/repositories/authentication_repository.dart';

class MockAuthenticationLocalDataSource extends Mock
    implements AuthenticationLocalDataSource {}

class MockAuthenticationProvider extends Mock
    implements AuthenticationProvider {}

class FakeAuthenticationData extends Fake implements AuthenticationData {}

void main() {
  late AuthenticationRepository repository;
  late MockAuthenticationLocalDataSource mockLocalDataSource;
  late MockAuthenticationProvider mockAuthenticationProvider;

  setUpAll(() {
    registerFallbackValue(FakeAuthenticationData());
  });

  setUp(() {
    mockLocalDataSource = MockAuthenticationLocalDataSource();
    mockAuthenticationProvider = MockAuthenticationProvider();
    repository = AuthenticationRepositoryImpl(
      authenticationProvider: mockAuthenticationProvider,
      localDataSource: mockLocalDataSource,
    );
  });

  test('dispose', () async {
    when(() => mockLocalDataSource.getAuthenticationData())
        .thenAnswer((_) async => null);
    repository.dispose();
    expectLater(
      repository.authenticationData,
      emitsThrough(emitsDone),
    );
  });

  group('login', () {
    const tAuthenticationDataModel = AuthenticationDataModel(
      token: 'token',
      id: 123,
      username: 'test-username',
    );
    const AuthenticationData tAuthenticationData = tAuthenticationDataModel;
    test('login saves the data to cache', () async {
      // arrange
      when(
        () => mockLocalDataSource.cacheAuthenticationData(
          tAuthenticationDataModel,
        ),
      ).thenAnswer((_) async => true);
      final expected = [
        Left(CacheFailure()),
        const Right(tAuthenticationData),
      ];
      // assert later
      expectLater(repository.authenticationData, emitsInOrder(expected));
      // act
      final result = await repository.login(tAuthenticationData);
      // assert
      expect(result, true);
      verify(
        () => mockLocalDataSource.cacheAuthenticationData(
          tAuthenticationDataModel,
        ),
      ).called(1);
      verify(
        () => mockAuthenticationProvider.cacheAuthenticationData(
          tAuthenticationData,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockAuthenticationProvider);
    });

    test('failed login does not update stream', () async {
      // arrange
      when(
        () => mockLocalDataSource.cacheAuthenticationData(
          tAuthenticationDataModel,
        ),
      ).thenThrow(CacheException());
      final expected = [
        Left(CacheFailure()),
      ];
      // assert later
      expectLater(repository.authenticationData, emitsInOrder(expected));
      // act
      final result = await repository.login(tAuthenticationData);
      // assert
      expect(result, false);
      verify(
        () => mockLocalDataSource.cacheAuthenticationData(
          tAuthenticationDataModel,
        ),
      ).called(1);
      verifyNever(
          () => mockAuthenticationProvider.cacheAuthenticationData(any()));
      verifyNoMoreInteractions(mockAuthenticationProvider);
    });
  });

  group('logout', () {
    test('logout removes data from the cache', () async {
      // arrange
      when(
        () => mockLocalDataSource.removeAuthenticationData(),
      ).thenAnswer((_) async => true);
      final expected = [
        Left(CacheFailure()),
        Left(AuthenticationFailure()),
      ];
      // assert later
      expectLater(repository.authenticationData, emitsInOrder(expected));
      // act
      final result = await repository.logout();
      // assert
      expect(result, true);
      verify(() => mockLocalDataSource.removeAuthenticationData()).called(1);

      verify(() => mockAuthenticationProvider.removeAuthenticationData())
          .called(1);
      verifyNoMoreInteractions(mockAuthenticationProvider);
    });

    test('failed logout does not update stream', () async {
      // arrange
      when(
        () => mockLocalDataSource.removeAuthenticationData(),
      ).thenAnswer((_) async => false);
      final expected = [
        Left(CacheFailure()),
      ];
      // assert later
      expectLater(repository.authenticationData, emitsInOrder(expected));
      // act
      final result = await repository.logout();
      // assert
      expect(result, false);
      verify(() => mockLocalDataSource.removeAuthenticationData()).called(1);
      verifyNever(() => mockAuthenticationProvider.removeAuthenticationData());
      verifyNoMoreInteractions(mockAuthenticationProvider);
    });
  });

  group('success responses', () {
    const tAuthenticationDataModel = AuthenticationDataModel(
      token: 'token',
      id: 123,
      username: 'test-username',
    );
    const AuthenticationData tAuthenticationData = tAuthenticationDataModel;

    test(
      'should return locally cached data when present',
      () async {
        // arrange
        when(() => mockLocalDataSource.getAuthenticationData())
            .thenAnswer((_) async => tAuthenticationDataModel);
        // act
        await repository.checkAuthenticatedData();
        // assert
        verify(() => mockLocalDataSource.getAuthenticationData()).called(1);
        final expected = [
          const Right(tAuthenticationData),
        ];
        // assert later
        expectLater(repository.authenticationData, emitsInOrder(expected));
        // assert
        verifyNoMoreInteractions(mockLocalDataSource);
        verify(
          () => mockAuthenticationProvider.cacheAuthenticationData(
            tAuthenticationData,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockAuthenticationProvider);
      },
    );
  });

  group('error responses', () {
    test(
      'should return AuthenticationFailure when no cached data present',
      () async {
        // arrange
        when(() => mockLocalDataSource.getAuthenticationData())
            .thenAnswer((_) async => null);
        // act
        repository.checkAuthenticatedData();
        // assert
        verify(() => mockLocalDataSource.getAuthenticationData()).called(1);
        final expected = [
          Left(AuthenticationFailure()),
        ];
        // assert later
        expectLater(repository.authenticationData, emitsInOrder(expected));
        // act
        verifyNoMoreInteractions(mockLocalDataSource);
        verifyNever(
          () => mockAuthenticationProvider.cacheAuthenticationData(any()),
        );
        verifyNoMoreInteractions(mockAuthenticationProvider);
      },
    );

    test(
      'should return CacheFailure on error',
      () async {
        // arrange
        when(() => mockLocalDataSource.getAuthenticationData())
            .thenThrow(Exception());
        // act
        repository.checkAuthenticatedData();
        // assert
        verify(() => mockLocalDataSource.getAuthenticationData()).called(1);
        final expected = [
          Left(CacheFailure()),
        ];
        // assert later
        expectLater(repository.authenticationData, emitsInOrder(expected));
        // act
        verifyNoMoreInteractions(mockLocalDataSource);
        verifyNever(
          () => mockAuthenticationProvider.cacheAuthenticationData(any()),
        );
        verifyNoMoreInteractions(mockAuthenticationProvider);
      },
    );
  });
}
