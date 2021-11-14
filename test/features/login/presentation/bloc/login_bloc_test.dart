import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';

import 'package:wikiclimb_flutter_frontend/core/error/failure.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/entities/authentication_data.dart';
import 'package:wikiclimb_flutter_frontend/features/login/domain/entities/entities.dart';
import 'package:wikiclimb_flutter_frontend/features/login/domain/usecases/log_in_with_username_password.dart';
import 'package:wikiclimb_flutter_frontend/features/login/presentation/bloc/login_bloc.dart';

class MockLogInWithUsernamePassword extends Mock
    implements LogInWithUsernamePassword {}

void main() {
  late LogInWithUsernamePassword loginUsecase;

  setUp(() {
    loginUsecase = MockLogInWithUsernamePassword();
  });

  test('initial state should be clean', () {
    final loginBloc = LoginBloc(loginUseCase: loginUsecase);
    expect(
        loginBloc.state,
        equals(const LoginState(
          status: FormzStatus.pure,
          username: Username.pure(),
          password: Password.pure(),
        )));
  });

  group('login submitted', () {
    const tAuthenticationData = AuthenticationData(
      token: 'test-token',
      id: 321,
      username: 'test-username',
    );
    const Right<Failure, AuthenticationData> tSuccessResponse =
        Right(tAuthenticationData);

    blocTest<LoginBloc, LoginState>(
      'emits [submissionInProgress, submissionSuccess] '
      'when login succeeds',
      setUp: () {
        when(
          () => loginUsecase.call(const Params(
            username: 'username',
            password: 'password',
          )),
        ).thenAnswer((_) => Future.value(tSuccessResponse));
      },
      build: () => LoginBloc(
        loginUseCase: loginUsecase,
      ),
      act: (bloc) {
        bloc
          ..add(const LoginUsernameChanged('username'))
          ..add(const LoginPasswordChanged('password'))
          ..add(const LoginSubmitted());
      },
      expect: () => const <LoginState>[
        LoginState(
          username: Username.dirty('username'),
          status: FormzStatus.invalid,
        ),
        LoginState(
          username: Username.dirty('username'),
          password: Password.dirty('password'),
          status: FormzStatus.valid,
        ),
        LoginState(
          username: Username.dirty('username'),
          password: Password.dirty('password'),
          status: FormzStatus.submissionInProgress,
        ),
        LoginState(
          username: Username.dirty('username'),
          password: Password.dirty('password'),
          status: FormzStatus.submissionSuccess,
        ),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'emits [LoginInProgress, LoginFailure] when logIn fails',
      setUp: () {
        when(
          () => loginUsecase.call(const Params(
            username: 'username',
            password: 'password',
          )),
        ).thenThrow(Exception('oops'));
      },
      build: () => LoginBloc(
        loginUseCase: loginUsecase,
      ),
      act: (bloc) {
        bloc
          ..add(const LoginUsernameChanged('username'))
          ..add(const LoginPasswordChanged('password'))
          ..add(const LoginSubmitted());
      },
      expect: () => const <LoginState>[
        LoginState(
          username: Username.dirty('username'),
          status: FormzStatus.invalid,
        ),
        LoginState(
          username: Username.dirty('username'),
          password: Password.dirty('password'),
          status: FormzStatus.valid,
        ),
        LoginState(
          username: Username.dirty('username'),
          password: Password.dirty('password'),
          status: FormzStatus.submissionInProgress,
        ),
        LoginState(
          username: Username.dirty('username'),
          password: Password.dirty('password'),
          status: FormzStatus.submissionFailure,
        ),
      ],
    );
  });

  group('login request', () {
    // const tUsername = 'test-user';
    // const tPassword = 'test-password';
    // const tParams = Params(
    //   username: tUsername,
    //   password: tPassword,
    // );
    // const tAuthenticationData = AuthenticationData(
    //   token: 'test-token',
    //   id: 123,
    // );
    // test('successful login should return success state', () async {
    //   when(loginUsecase.call(tParams)).thenAnswer(
    //     (_) async => const Right(tAuthenticationData),
    //   );
    //   final expected = [
    //     LoginLoading(),
    //     LoginSuccess(),
    //   ];
    //   expectLater(bloc.stream, emitsInOrder(expected));
    //   bloc.add(const LoginRequested(
    //     username: tUsername,
    //     password: tPassword,
    //   ));
    // });

    // test('Login failure should return [LoginError]', () async {
    //   when(loginUsecase.call(tParams)).thenAnswer(
    //     (_) async => Left(UnauthorizedFailure()),
    //   );
    //   final expected = [
    //     LoginLoading(),
    //     const LoginError(message: LoginBloc.loginFailedMessage),
    //   ];
    //   bloc.add(const LoginRequested(
    //     username: tUsername,
    //     password: tPassword,
    //   ));
    //   expectLater(bloc.stream, emitsInOrder(expected));
    // });

    // test('Server error should return [LoginError]', () async {
    //   when(loginUsecase.call(tParams)).thenAnswer(
    //     (_) async => Left(ServerFailure()),
    //   );
    //   final expected = [
    //     LoginLoading(),
    //     const LoginError(message: LoginBloc.serverError),
    //   ];
    //   bloc.add(const LoginRequested(
    //     username: tUsername,
    //     password: tPassword,
    //   ));
    //   expectLater(bloc.stream, emitsInOrder(expected));
    // });

    // test('on [NetworkFailure] should return [LoginError]', () async {
    //   when(loginUsecase.call(tParams)).thenAnswer(
    //     (_) async => Left(NetworkFailure()),
    //   );
    //   final expected = [
    //     LoginLoading(),
    //     const LoginError(message: LoginBloc.networkError),
    //   ];
    //   bloc.add(const LoginRequested(
    //     username: tUsername,
    //     password: tPassword,
    //   ));
    //   expectLater(bloc.stream, emitsInOrder(expected));
    // });

    // test('double tap should not trigger two cycles', () async {
    //   when(loginUsecase.call(tParams)).thenAnswer(
    //     (_) async => const Right(tAuthenticationData),
    //   );
    //   final expected = [
    //     LoginLoading(),
    //     LoginSuccess(),
    //   ];
    //   bloc.add(const LoginRequested(
    //     username: tUsername,
    //     password: tPassword,
    //   ));
    //   bloc.add(const LoginRequested(
    //     username: tUsername,
    //     password: tPassword,
    //   ));
    //   expectLater(bloc.stream, emitsInOrder(expected));
    // });
  });
}
