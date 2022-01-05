// ignore_for_file: prefer_const_constructors

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wikiclimb_flutter_frontend/core/entities/response.dart';
import 'package:wikiclimb_flutter_frontend/core/error/failure.dart';
import 'package:wikiclimb_flutter_frontend/features/password_recovery/domain/entities/password_recovery_params.dart';
import 'package:wikiclimb_flutter_frontend/features/password_recovery/domain/repositories/password_recovery_repository.dart';
import 'package:wikiclimb_flutter_frontend/features/password_recovery/domain/usecases/request_password_recovery_email.dart';

class MockPasswordRecoveryRepository extends Mock
    implements PasswordRecoveryRepository {}

void main() {
  late RequestPasswordRecoveryEmail usecase;
  late MockPasswordRecoveryRepository mockRepository;
  const tEmail = 'example@domain.com';
  final successResponse = Response((r) => r
    ..error = false
    ..message = 'all good');
  final tParams = PasswordRecoveryParams(email: tEmail);

  setUp(() {
    mockRepository = MockPasswordRecoveryRepository();
    usecase = RequestPasswordRecoveryEmail(mockRepository);
  });

  test('should pipe successful return', () async {
    when(() => mockRepository.requestPasswordRecoveryEmail(params: tParams))
        .thenAnswer((_) async => Right(successResponse));
    final result = await usecase(tParams);
    expect(result, Right(successResponse));
    verify(() => mockRepository.requestPasswordRecoveryEmail(params: tParams))
        .called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should pipe failures', () async {
    when(() => mockRepository.requestPasswordRecoveryEmail(params: tParams))
        .thenAnswer((_) async => Left(ServerFailure()));
    final result = await usecase(tParams);
    expect(result, Left(ServerFailure()));
    verify(() => mockRepository.requestPasswordRecoveryEmail(params: tParams))
        .called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
