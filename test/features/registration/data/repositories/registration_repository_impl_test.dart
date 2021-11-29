// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wikiclimb_flutter_frontend/core/entities/response.dart';
import 'package:wikiclimb_flutter_frontend/core/error/exception.dart';
import 'package:wikiclimb_flutter_frontend/core/error/failure.dart';
import 'package:wikiclimb_flutter_frontend/features/registration/data/datasources/registration_remote_data_source.dart';
import 'package:wikiclimb_flutter_frontend/features/registration/data/repositories/registration_repository_impl.dart';
import 'package:wikiclimb_flutter_frontend/features/registration/domain/entities/sign_up_params.dart';
import 'package:wikiclimb_flutter_frontend/features/registration/domain/repositories/registration_repository.dart';

class MockRemoteDataSource extends Mock
    implements RegistrationRemoteDataSource {}

void main() {
  late RegistrationRemoteDataSource mockRemoteDataSource;
  late RegistrationRepository repository;
  final tParams = SignUpParams((p) => p
    ..email = 'email'
    ..username = 'username'
    ..password = 'password');
  const tUsername = 'test-username';
  final tResponse = Response((r) => r
    ..error = false
    ..message = 'm');

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    repository = RegistrationRepositoryImpl(mockRemoteDataSource);
  });

  group('check username available', () {
    test('when available', () async {
      when(() => mockRemoteDataSource.isUsernameAvailable(tUsername))
          .thenAnswer((_) async => true);
      final result = await repository.isUsernameAvailable(tUsername);
      expect(result, Right(true));
    });

    test('when not available', () async {
      when(() => mockRemoteDataSource.isUsernameAvailable(tUsername))
          .thenAnswer((_) async => false);
      final result = await repository.isUsernameAvailable(tUsername);
      expect(result, Right(false));
    });

    test('when exception', () async {
      when(() => mockRemoteDataSource.isUsernameAvailable(tUsername))
          .thenThrow(NetworkException());
      final result = await repository.isUsernameAvailable(tUsername);
      expect(result, Left(NetworkFailure()));
    });
  });

  group('check register', () {
    test('when success', () async {
      when(() => mockRemoteDataSource.register(tParams))
          .thenAnswer((_) async => tResponse);
      final result = await repository.signUpWithEmailPassword(tParams);
      expect(result, Right(tResponse));
    });
    test('when failed', () async {
      when(() => mockRemoteDataSource.register(tParams))
          .thenAnswer((_) async => tResponse);
      final result = await repository.signUpWithEmailPassword(tParams);
      expect(result, Right(tResponse));
    });
    test('when exception', () async {
      when(() => mockRemoteDataSource.register(tParams))
          .thenThrow(SocketException('message'));
      final result = await repository.signUpWithEmailPassword(tParams);
      expect(result, Left(ApplicationFailure()));
    });
  });
}
