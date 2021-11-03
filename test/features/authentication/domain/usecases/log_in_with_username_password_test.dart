import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/entities/authentication_data.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/usecases/log_in_with_username_password.dart';

import 'log_in_with_username_password_test.mocks.dart';

@GenerateMocks([AuthenticationRepository])
void main() {
  late LogInWithUsernamePassword usecase;
  late MockAuthenticationRepository mockAuthenticationRepository;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    usecase = LogInWithUsernamePassword(mockAuthenticationRepository);
  });

  const tUsername = 'test-username';
  const tPassword = 'very_secret';
  const tAuthenticationData =
      AuthenticationData(token: 'secret-token', id: 123);

  test('should return authentication data when successful sign up', () async {
    when(
      mockAuthenticationRepository.logInWithUsernamePassword(
        username: argThat(isNotNull, named: 'username'),
        password: argThat(isNotNull, named: 'password'),
      ),
    ).thenAnswer((_) async {
      return const Right(tAuthenticationData);
    });

    final result =
        await usecase(const Params(username: tUsername, password: tPassword));
    expect(result, const Right(tAuthenticationData));
    verify(mockAuthenticationRepository.logInWithUsernamePassword(
        username: tUsername, password: tPassword));
    verifyNoMoreInteractions(mockAuthenticationRepository);
  });
}
