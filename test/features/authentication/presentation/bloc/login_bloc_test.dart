import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:wikiclimb_flutter_frontend/core/error/failure.dart';
import 'package:wikiclimb_flutter_frontend/core/utils/validator.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/entities/authentication_data.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/usecases/log_in_with_username_password.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/presentation/bloc/login_bloc.dart';
import 'login_bloc_test.mocks.dart';

@GenerateMocks([LogInWithUsernamePassword, ValidatorImpl])
void main() {
  late LoginBloc bloc;
  late LogInWithUsernamePassword loginUsecase;

  setUp(() {
    loginUsecase = MockLogInWithUsernamePassword();
    bloc = LoginBloc(
      loginUsecase: loginUsecase,
    );
  });

  test('initial state should be LoginInitial', () {
    expect(bloc.state, equals(LoginInitial()));
  });

  group('login request', () {
    const tUsername = 'test-user';
    const tPassword = 'test-password';
    const tParams = Params(
      username: tUsername,
      password: tPassword,
    );
    const tAuthenticationData = AuthenticationData(
      token: 'test-token',
      id: 123,
    );
    test('successful login should return success state', () async {
      when(loginUsecase.call(tParams)).thenAnswer(
        (_) async => const Right(tAuthenticationData),
      );
      final expected = [
        LoginLoading(),
        LoginSuccess(),
      ];
      bloc.add(const LoginRequested(
        username: tUsername,
        password: tPassword,
      ));
      expectLater(bloc.stream, emitsInOrder(expected));
    });

    test('Login failure should return [LoginError]', () async {
      when(loginUsecase.call(tParams)).thenAnswer(
        (_) async => Left(UnauthorizedFailure()),
      );
      final expected = [
        LoginLoading(),
        const LoginError(message: LoginBloc.loginFailedMessage),
      ];
      bloc.add(const LoginRequested(
        username: tUsername,
        password: tPassword,
      ));
      expectLater(bloc.stream, emitsInOrder(expected));
    });

    test('Server error should return [LoginError]', () async {
      when(loginUsecase.call(tParams)).thenAnswer(
        (_) async => Left(ServerFailure()),
      );
      final expected = [
        LoginLoading(),
        const LoginError(message: LoginBloc.serverError),
      ];
      bloc.add(const LoginRequested(
        username: tUsername,
        password: tPassword,
      ));
      expectLater(bloc.stream, emitsInOrder(expected));
    });

    test('on [NetworkFailure] should return [LoginError]', () async {
      when(loginUsecase.call(tParams)).thenAnswer(
        (_) async => Left(NetworkFailure()),
      );
      final expected = [
        LoginLoading(),
        const LoginError(message: LoginBloc.networkError),
      ];
      bloc.add(const LoginRequested(
        username: tUsername,
        password: tPassword,
      ));
      expectLater(bloc.stream, emitsInOrder(expected));
    });

    test('double tap should not trigger two cycles', () async {
      when(loginUsecase.call(tParams)).thenAnswer(
        (_) async => const Right(tAuthenticationData),
      );
      final expected = [
        LoginLoading(),
        LoginSuccess(),
      ];
      bloc.add(const LoginRequested(
        username: tUsername,
        password: tPassword,
      ));
      bloc.add(const LoginRequested(
        username: tUsername,
        password: tPassword,
      ));
      expectLater(bloc.stream, emitsInOrder(expected));
    });
  });
}
