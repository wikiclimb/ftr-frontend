import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/entities/authentication_data.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/usecases/sign_up_with_email_password.dart';

import 'sign_up_with_email_password_test.mocks.dart';

@GenerateMocks([AuthenticationRepository])
void main() {
  late SignUpWithEmailPassword usecase;
  late MockAuthenticationRepository mockAuthenticationRepository;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    usecase = SignUpWithEmailPassword(mockAuthenticationRepository);
  });

  const tEmail = 'test@example.com';
  const tPassword = 'very_secret';
  const tAuthenticationData =
      AuthenticationData(token: 'secret-token', id: 123);

  test('should return authentication data when successful sign up', () async {
    when(
      mockAuthenticationRepository.signUpWithEmailPassword(
        email: argThat(isNotNull, named: 'email'),
        password: argThat(isNotNull, named: 'password'),
      ),
    ).thenAnswer((_) async {
      return const Right(tAuthenticationData);
    });

    final result = await usecase.execute(email: tEmail, password: tPassword);
    expect(result, const Right(tAuthenticationData));
    verify(mockAuthenticationRepository.signUpWithEmailPassword(
        email: tEmail, password: tPassword));
    verifyNoMoreInteractions(mockAuthenticationRepository);
  });
}
