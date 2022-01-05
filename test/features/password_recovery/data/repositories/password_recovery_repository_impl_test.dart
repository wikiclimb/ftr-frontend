// ignore_for_file: prefer_const_constructors

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wikiclimb_flutter_frontend/core/entities/response.dart';
import 'package:wikiclimb_flutter_frontend/core/error/exception.dart';
import 'package:wikiclimb_flutter_frontend/core/error/failure.dart';
import 'package:wikiclimb_flutter_frontend/features/password_recovery/data/datasources/password_recovery_remote_data_source.dart';
import 'package:wikiclimb_flutter_frontend/features/password_recovery/data/repositories/password_recovery_repository_impl.dart';
import 'package:wikiclimb_flutter_frontend/features/password_recovery/domain/entities/password_recovery_params.dart';
import 'package:wikiclimb_flutter_frontend/features/password_recovery/domain/repositories/password_recovery_repository.dart';

class MockRemoteDataSource extends Mock
    implements PasswordRecoveryRemoteDataSource {}

void main() {
  const tEmail = 'test@example.com';
  late PasswordRecoveryRemoteDataSource mockRemoteDataSource;
  late PasswordRecoveryRepository repository;
  final tParams = PasswordRecoveryParams(email: tEmail);
  final successResponse = Response((r) => r
    ..error = false
    ..message = 'OK');

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    repository = PasswordRecoveryRepositoryImpl(mockRemoteDataSource);
  });

  group('request password recovery email', () {
    test('success response', () async {
      when(() => mockRemoteDataSource.requestPasswordRecoveryEmail(tParams))
          .thenAnswer((_) async => successResponse);
      final result =
          await repository.requestPasswordRecoveryEmail(params: tParams);
      expect(result, Right(successResponse));
      verify(() => mockRemoteDataSource.requestPasswordRecoveryEmail(tParams))
          .called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('exception handling', () async {
      when(() => mockRemoteDataSource.requestPasswordRecoveryEmail(tParams))
          .thenThrow(NetworkException());
      final result =
          await repository.requestPasswordRecoveryEmail(params: tParams);
      expect(result, Left(NetworkFailure()));
      verify(() => mockRemoteDataSource.requestPasswordRecoveryEmail(tParams))
          .called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });
}
