import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/entities/authentication_data.dart';
import 'package:wikiclimb_flutter_frontend/features/login/domain/repositories/login_repository.dart';
import 'package:wikiclimb_flutter_frontend/features/login/domain/usecases/log_in_with_username_password.dart';

import 'log_in_with_username_password_test.mocks.dart';

@GenerateMocks([LoginRepository])
void main() {
  late LogInWithUsernamePassword usecase;
  late MockLoginRepository mockLoginRepository;

  setUp(() {
    mockLoginRepository = MockLoginRepository();
    usecase = LogInWithUsernamePassword(mockLoginRepository);
  });

  const tUsername = 'test-username';
  const tPassword = 'very_secret';
  const tAuthenticationData = AuthenticationData(
    token: 'secret-token',
    id: 123,
    username: 'test-username',
  );

  test('should return authentication data when successful sign up', () async {
    when(
      mockLoginRepository.logInWithUsernamePassword(
        username: argThat(isNotNull, named: 'username'),
        password: argThat(isNotNull, named: 'password'),
      ),
    ).thenAnswer((_) async {
      return const Right(tAuthenticationData);
    });

    final result =
        await usecase(const Params(username: tUsername, password: tPassword));
    expect(result, const Right(tAuthenticationData));
    verify(mockLoginRepository.logInWithUsernamePassword(
        username: tUsername, password: tPassword));
    verifyNoMoreInteractions(mockLoginRepository);
  });

  test('login usecase params props should return username and password', () {
    const params = Params(username: 'test-username', password: 'test-password');
    expect(params.props, ['test-username', 'test-password']);
  });
}
