import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:wikiclimb_flutter_frontend/core/error/exception.dart';
import 'package:wikiclimb_flutter_frontend/core/error/failure.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/data/datasources/authentication_local_data_source.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/data/models/authentication_data_model.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/entities/authentication_data.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/repositories/authentication_repository.dart';

import 'authentication_repository_impl_test.mocks.dart';

@GenerateMocks([AuthenticationLocalDataSource])
void main() {
  late AuthenticationRepository repository;
  late MockAuthenticationLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockAuthenticationLocalDataSource();
    repository = AuthenticationRepositoryImpl(
      localDataSource: mockLocalDataSource,
    );
  });

  group('success responses', () {
    const tAuthenticationDataModel = AuthenticationDataModel(
      token: 'token',
      id: 123,
    );
    const AuthenticationData tAuthenticationData = tAuthenticationDataModel;

    test(
      'should return locally cached data when present',
      () async {
        // arrange
        when(mockLocalDataSource.getAuthenticationData())
            .thenAnswer((_) async => tAuthenticationDataModel);
        // act
        final result = await repository.getAuthenticationData();
        // assert
        verify(mockLocalDataSource.getAuthenticationData()).called(1);
        expect(result, equals(const Right(tAuthenticationData)));
        verifyNoMoreInteractions(mockLocalDataSource);
      },
    );
  });

  group('error responses', () {
    test(
      'should return AuthenticationFailure when no cached data present',
      () async {
        // arrange
        when(mockLocalDataSource.getAuthenticationData())
            .thenThrow(CacheException());
        // act
        final result = await repository.getAuthenticationData();
        // assert
        verify(mockLocalDataSource.getAuthenticationData()).called(1);
        expect(result, equals(Left(AuthenticationFailure())));
        verifyNoMoreInteractions(mockLocalDataSource);
      },
    );

    test(
      'should return CacheFailure on error',
      () async {
        // arrange
        when(mockLocalDataSource.getAuthenticationData())
            .thenThrow(Exception());
        // act
        final result = await repository.getAuthenticationData();
        // assert
        verify(mockLocalDataSource.getAuthenticationData()).called(1);
        expect(result, equals(Left(CacheFailure())));
        verifyNoMoreInteractions(mockLocalDataSource);
      },
    );
  });
}
