import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:wikiclimb_flutter_frontend/core/error/failure.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/entities/authentication_data.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/usecases/authenticate.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/presentation/bloc/authentication_bloc.dart';

class MockAuthenticate extends Mock implements Authenticate {}

class FakeStreamController extends Fake
    implements StreamController<Either<Failure, AuthenticationData>> {}

void main() {
  late MockAuthenticate usecase;

  setUp(() {
    usecase = MockAuthenticate();
    when(() => usecase.subscribe).thenAnswer((_) => const Stream.empty());
  });

  test('initial state is AuthenticationState.unknown', () {
    final authenticationBloc = AuthenticationBloc(
      usecase: usecase,
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
        when(() => usecase.subscribe).thenAnswer(
          (_) => Stream.value(const Right(tAuthenticationData)),
        );
      },
      build: () => AuthenticationBloc(
        usecase: usecase,
      ),
      expect: () => const <AuthenticationState>[
        AuthenticationAuthenticated(tAuthenticationData),
      ],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits [unauthenticated] when usecase returns failure',
      setUp: () {
        when(() => usecase.subscribe).thenAnswer(
          (_) => Stream.value(Left(AuthenticationFailure())),
        );
      },
      build: () => AuthenticationBloc(
        usecase: usecase,
      ),
      expect: () => <AuthenticationState>[
        AuthenticationUnauthenticated(),
      ],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'calls usecase() when authentication check requested',
      build: () => AuthenticationBloc(
        usecase: usecase,
      ),
      act: (bloc) => bloc.add(AuthenticationRequested()),
      verify: (_) {
        verify(() => usecase()).called(1);
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
}
