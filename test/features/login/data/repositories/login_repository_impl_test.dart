import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:wikiclimb_flutter_frontend/core/error/exception.dart';
import 'package:wikiclimb_flutter_frontend/core/error/failure.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/data/datasources/authentication_local_data_source.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/data/models/authentication_data_model.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/entities/authentication_data.dart';
import 'package:wikiclimb_flutter_frontend/features/login/data/datasources/login_remote_data_source.dart';
import 'package:wikiclimb_flutter_frontend/features/login/data/repositories/login_repository_impl.dart';

import 'login_repository_impl_test.mocks.dart';

@GenerateMocks([LoginRemoteDataSource, AuthenticationLocalDataSource])
void main() {
  late LoginRepositoryImpl repository;
  late MockLoginRemoteDataSource mockRemoteDataSource;
  late MockAuthenticationLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockLoginRemoteDataSource();
    mockLocalDataSource = MockAuthenticationLocalDataSource();
    repository = LoginRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  group('login', () {
    const tUsername = 'username';
    const tPassword = 'very-secret';
    const tAuthenticationDataModel = AuthenticationDataModel(
      token: 'token',
      id: 123,
      username: 'test-username',
    );
    const AuthenticationData tAuthenticationData = tAuthenticationDataModel;

    setUp(() {
      when(mockLocalDataSource.cacheAuthenticationData(any))
          .thenAnswer((_) async => true);
    });

    test(
      'should return remote data when the call '
      'to remote data source is successful',
      () async {
        when(mockRemoteDataSource.login(
          username: tUsername,
          password: tPassword,
        )).thenAnswer((_) async => tAuthenticationDataModel);
        final result = await repository.logInWithUsernamePassword(
          username: tUsername,
          password: tPassword,
        );
        expect(result, equals(const Right(tAuthenticationData)));
        verify(mockRemoteDataSource.login(
          username: tUsername,
          password: tPassword,
        ));
      },
    );

    test(
      'should cache the data locally when the call to '
      'remote data source is successful',
      () async {
        when(mockRemoteDataSource.login(
          username: tUsername,
          password: tPassword,
        )).thenAnswer((_) async => tAuthenticationDataModel);
        await repository.logInWithUsernamePassword(
          username: tUsername,
          password: tPassword,
        );
        verify(mockRemoteDataSource.login(
          username: tUsername,
          password: tPassword,
        ));
        verify(mockLocalDataSource
            .cacheAuthenticationData(tAuthenticationDataModel));
      },
    );

    test(
      'should return UnauthorizedFailure when the call to '
      'remote data source returns login failure',
      () async {
        when(mockRemoteDataSource.login(
          username: tUsername,
          password: tPassword,
        )).thenThrow(UnauthorizedException());
        final result = await repository.logInWithUsernamePassword(
          username: tUsername,
          password: tPassword,
        );
        verify(mockRemoteDataSource.login(
          username: tUsername,
          password: tPassword,
        ));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(UnauthorizedFailure())));
      },
    );

    test(
      'should return [ServerFailure] when the call to '
      'remote data source returns [ServerException]',
      () async {
        when(mockRemoteDataSource.login(
          username: tUsername,
          password: tPassword,
        )).thenThrow(ServerException());
        final result = await repository.logInWithUsernamePassword(
          username: tUsername,
          password: tPassword,
        );
        verify(mockRemoteDataSource.login(
          username: tUsername,
          password: tPassword,
        ));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      },
    );

    test(
      'should return [NetworkFailure] when the call to '
      'remote data source returns [NetworkException]',
      () async {
        when(mockRemoteDataSource.login(
          username: tUsername,
          password: tPassword,
        )).thenThrow(NetworkException());
        final result = await repository.logInWithUsernamePassword(
          username: tUsername,
          password: tPassword,
        );
        verify(mockRemoteDataSource.login(
          username: tUsername,
          password: tPassword,
        ));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(NetworkFailure())));
      },
    );

    test(
      'should return [ServerFailure] when the call to '
      'remote data source returns other [Exception]',
      () async {
        when(mockRemoteDataSource.login(
          username: tUsername,
          password: tPassword,
        )).thenThrow(Exception());
        final result = await repository.logInWithUsernamePassword(
          username: tUsername,
          password: tPassword,
        );
        verify(mockRemoteDataSource.login(
          username: tUsername,
          password: tPassword,
        ));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      },
    );
  });
}
