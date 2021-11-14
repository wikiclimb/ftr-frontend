// ignore_for_file: prefer_const_constructors
import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:wikiclimb_flutter_frontend/core/error/failure.dart';
import 'package:wikiclimb_flutter_frontend/core/usecases/usecase.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/entities/authentication_data.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/usecases/authenticate.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/usecases/logout.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/presentation/bloc/authentication_bloc.dart';

class MockAuthenticate extends Mock implements Authenticate {}

class MockLogout extends Mock implements Logout {}

class FakeStreamController extends Fake
    implements StreamController<Either<Failure, AuthenticationData>> {}

void main() {
  late MockAuthenticate mockAuthenticateUseCase;
  late Logout mockLogoutUseCase;

  setUp(() {
    mockAuthenticateUseCase = MockAuthenticate();
    mockLogoutUseCase = MockLogout();
    when(() => mockAuthenticateUseCase.subscribe)
        .thenAnswer((_) => const Stream.empty());
  });

  test('initial state is AuthenticationState.unknown', () {
    final authenticationBloc = AuthenticationBloc(
      usecase: mockAuthenticateUseCase,
      logout: mockLogoutUseCase,
    );
    expect(authenticationBloc.state, AuthenticationInitial());
    authenticationBloc.close();
  });

  group('success responses', () {
    const tAuthenticationData = AuthenticationData(
      token: 'test-token',
      id: 123,
      username: 'test-username',
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits [authenticated] when usecase returns auth data',
      setUp: () {
        when(() => mockAuthenticateUseCase.subscribe).thenAnswer(
          (_) => Stream.value(const Right(tAuthenticationData)),
        );
      },
      build: () => AuthenticationBloc(
        usecase: mockAuthenticateUseCase,
        logout: mockLogoutUseCase,
      ),
      expect: () => const <AuthenticationState>[
        AuthenticationAuthenticated(tAuthenticationData),
      ],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits [unauthenticated] when usecase returns failure',
      setUp: () {
        when(() => mockAuthenticateUseCase.subscribe).thenAnswer(
          (_) => Stream.value(Left(AuthenticationFailure())),
        );
      },
      build: () => AuthenticationBloc(
        usecase: mockAuthenticateUseCase,
        logout: mockLogoutUseCase,
      ),
      expect: () => <AuthenticationState>[
        AuthenticationUnauthenticated(),
      ],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'calls usecase() when authentication check requested',
      build: () => AuthenticationBloc(
        usecase: mockAuthenticateUseCase,
        logout: mockLogoutUseCase,
      ),
      act: (bloc) => bloc.add(AuthenticationRequested()),
      verify: (_) {
        verify(() => mockAuthenticateUseCase()).called(1);
      },
    );

    test('props', () {
      expect(
        const AuthenticationOk(tAuthenticationData),
        const AuthenticationOk(tAuthenticationData),
      );
      expect(
        const AuthenticationOk(tAuthenticationData).props,
        [tAuthenticationData],
      );
      expect(AuthenticationKo().props, []);
    });
  });

  group('logout', () {
    blocTest<AuthenticationBloc, AuthenticationState>(
      'calls logout() when logout requested',
      setUp: () {
        when(() => mockLogoutUseCase(NoParams()))
            .thenAnswer((_) async => Right(true));
      },
      build: () => AuthenticationBloc(
        usecase: mockAuthenticateUseCase,
        logout: mockLogoutUseCase,
      ),
      act: (bloc) => bloc.add(LogoutRequested()),
      verify: (_) {
        verify(() => mockLogoutUseCase(NoParams())).called(1);
      },
    );
  });
}
