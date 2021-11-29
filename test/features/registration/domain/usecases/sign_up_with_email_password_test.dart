// ignore_for_file: prefer_const_constructors

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wikiclimb_flutter_frontend/core/entities/response.dart';
import 'package:wikiclimb_flutter_frontend/core/error/failure.dart';
import 'package:wikiclimb_flutter_frontend/features/registration/domain/entities/sign_up_params.dart';
import 'package:wikiclimb_flutter_frontend/features/registration/domain/repositories/registration_repository.dart';
import 'package:wikiclimb_flutter_frontend/features/registration/domain/usecases/sign_up_with_email_password.dart';

class MockRegistrationRepository extends Mock
    implements RegistrationRepository {}

void main() {
  late RegistrationRepository mockRepository;
  late SignUpWithEmailPassword usecase;
  final signUpParams = SignUpParams((p) => p
    ..email = 'email'
    ..username = 'username'
    ..password = 'password');
  final tResponse = Response((r) => r
    ..error = false
    ..message = 'm');

  setUp(() {
    mockRepository = MockRegistrationRepository();
    usecase = SignUpWithEmailPassword(mockRepository);
  });

  test('should return true in success', () async {
    when(() => mockRepository.signUpWithEmailPassword(signUpParams))
        .thenAnswer((_) async => Right(tResponse));
    final result = await usecase(signUpParams);
    expect(result, Right(tResponse));
  });

  test('should return false in failed attempt', () async {
    final tResponseKo = Response((r) => r
      ..error = true
      ..message = 'error');
    when(() => mockRepository.signUpWithEmailPassword(signUpParams))
        .thenAnswer((_) async => Right(tResponseKo));
    final result = await usecase(signUpParams);
    expect(result, Right(tResponseKo));
  });

  test('should pipe failures', () async {
    when(() => mockRepository.signUpWithEmailPassword(signUpParams))
        .thenAnswer((_) async => Left(ApplicationFailure()));
    final result = await usecase(signUpParams);
    expect(result, Left(ApplicationFailure()));
  });
}
