import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:wikiclimb_flutter_frontend/core/error/exception.dart';
import 'package:wikiclimb_flutter_frontend/core/error/failure.dart';
import 'package:wikiclimb_flutter_frontend/core/network/network_info.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/data/datasources/authentication_local_data_source.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/data/models/authentication_data_model.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/entities/authentication_data.dart';

import 'authentication_repository_impl_test.mocks.dart';

@GenerateMocks([
  AuthenticationRemoteDataSource,
  AuthenticationLocalDataSource,
  NetworkInfo,
])
void main() {
  late AuthenticationRepositoryImpl repository;
  late MockAuthenticationRemoteDataSource mockRemoteDataSource;
  late MockAuthenticationLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockAuthenticationRemoteDataSource();
    mockLocalDataSource = MockAuthenticationLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = AuthenticationRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('login', () {
    const tUsername = 'username';
    const tPassword = 'very-secret';
    const tAuthenticationDataModel =
        AuthenticationDataModel(token: 'token', id: 123);
    const AuthenticationData tAuthenticationData = tAuthenticationDataModel;

    test('should check if the device is online', () {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.login(
        username: tUsername,
        password: tPassword,
      )).thenAnswer((_) async => tAuthenticationDataModel);
      repository.logInWithUsernamePassword(
          username: tUsername, password: tPassword);
      verify(mockNetworkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
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
          verify(mockRemoteDataSource.login(
            username: tUsername,
            password: tPassword,
          ));
          expect(result, equals(const Right(tAuthenticationData)));
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
        'should return server failure when the call to '
        'remote data source is unsuccessful',
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
    });

    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'should return last locally cached data when the '
        'cached data is present',
        () async {
          // arrange
          when(mockLocalDataSource.getAuthenticationData())
              .thenAnswer((_) async => tAuthenticationDataModel);
          // act
          final result = await repository.getAuthenticationData();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getAuthenticationData());
          expect(result, equals(const Right(tAuthenticationData)));
        },
      );
      test(
        'should return CacheFailure when there is no cached data present',
        () async {
          // arrange
          when(mockLocalDataSource.getAuthenticationData())
              .thenThrow(CacheException());
          // act
          final result = await repository.getAuthenticationData();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getAuthenticationData());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });
}
