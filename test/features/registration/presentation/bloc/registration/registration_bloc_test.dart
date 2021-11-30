// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wikiclimb_flutter_frontend/core/entities/response.dart';
import 'package:wikiclimb_flutter_frontend/core/error/failure.dart';
import 'package:wikiclimb_flutter_frontend/features/registration/domain/entities/sign_up_params.dart';
import 'package:wikiclimb_flutter_frontend/features/registration/domain/usecases/sign_up_with_email_password.dart';
import 'package:wikiclimb_flutter_frontend/features/registration/presentation/bloc/registration/registration_bloc.dart';

class MockRegistrationWithUsernamePassword extends Mock
    implements SignUpWithEmailPassword {}

void main() {
  late SignUpWithEmailPassword signUpUseCase;
  const tEmail = 't-email@example.com';
  const tPassword = 'very-secret';
  const tUsername = 'test-username';
  final SignUpParams tParams = SignUpParams((p) => p
    ..email = tEmail
    ..password = tPassword
    ..username = tUsername);
  final Response tResponse = Response((r) => r
    ..message = 'message'
    ..error = false);
  final tState = RegistrationState(
    status: FormzStatus.pure,
    email: Email.pure(),
    username: Username.pure(),
    password: Password.pure(),
    passwordRepeat: Password.pure(),
  );

  setUpAll(() {
    registerFallbackValue(tParams);
    signUpUseCase = MockRegistrationWithUsernamePassword();
  });

  test('initial state should be clean', () {
    final registrationBloc = RegistrationBloc(signUp: signUpUseCase);
    expect(registrationBloc.state, equals(tState));
  });

  group('registration submitted', () {
    blocTest<RegistrationBloc, RegistrationState>(
      'emits [submissionInProgress, submissionSuccess] '
      'when registration succeeds',
      setUp: () {
        when(
          () => signUpUseCase(any()),
        ).thenAnswer((_) async => Right(tResponse));
      },
      build: () => RegistrationBloc(signUp: signUpUseCase),
      act: (bloc) {
        bloc
          ..add(RegistrationEmailChanged(tEmail))
          ..add(RegistrationUsernameChanged(tUsername))
          ..add(RegistrationPasswordChanged(tPassword))
          ..add(RegistrationPasswordRepeatChanged(tPassword))
          ..add(RegistrationSubmitted());
      },
      expect: () => <RegistrationState>[
        RegistrationState(
          email: Email.dirty(tEmail),
          status: FormzStatus.invalid,
        ),
        RegistrationState(
          email: Email.dirty(tEmail),
          username: Username.dirty(tUsername),
          status: FormzStatus.invalid,
        ),
        RegistrationState(
          email: Email.dirty(tEmail),
          username: Username.dirty(tUsername),
          password: Password.dirty(tPassword),
          status: FormzStatus.invalid,
        ),
        RegistrationState(
          email: Email.dirty(tEmail),
          username: Username.dirty(tUsername),
          password: Password.dirty(tPassword),
          passwordRepeat: Password.dirty(tPassword),
          status: FormzStatus.valid,
        ),
        RegistrationState(
          email: Email.dirty(tEmail),
          username: Username.dirty(tUsername),
          password: Password.dirty(tPassword),
          passwordRepeat: Password.dirty(tPassword),
          status: FormzStatus.submissionInProgress,
        ),
        RegistrationState(
          email: Email.dirty(tEmail),
          username: Username.dirty(tUsername),
          password: Password.dirty(tPassword),
          passwordRepeat: Password.dirty(tPassword),
          status: FormzStatus.submissionSuccess,
        ),
      ],
    );

    blocTest<RegistrationBloc, RegistrationState>(
      'emits [RegistrationInProgress, RegistrationFailure] on exception',
      setUp: () {
        when(
          () => signUpUseCase.call(any()),
        ).thenThrow(Exception('oops'));
      },
      build: () => RegistrationBloc(signUp: signUpUseCase),
      act: (bloc) {
        bloc
          ..add(RegistrationEmailChanged(tEmail))
          ..add(RegistrationUsernameChanged(tUsername))
          ..add(RegistrationPasswordChanged(tPassword))
          ..add(RegistrationPasswordRepeatChanged(tPassword))
          ..add(RegistrationSubmitted());
      },
      expect: () => const <RegistrationState>[
        RegistrationState(
          email: Email.dirty(tEmail),
          status: FormzStatus.invalid,
        ),
        RegistrationState(
          email: Email.dirty(tEmail),
          username: Username.dirty(tUsername),
          status: FormzStatus.invalid,
        ),
        RegistrationState(
          email: Email.dirty(tEmail),
          username: Username.dirty(tUsername),
          password: Password.dirty(tPassword),
          status: FormzStatus.invalid,
        ),
        RegistrationState(
          email: Email.dirty(tEmail),
          username: Username.dirty(tUsername),
          password: Password.dirty(tPassword),
          passwordRepeat: Password.dirty(tPassword),
          status: FormzStatus.valid,
        ),
        RegistrationState(
          email: Email.dirty(tEmail),
          username: Username.dirty(tUsername),
          password: Password.dirty(tPassword),
          passwordRepeat: Password.dirty(tPassword),
          status: FormzStatus.submissionInProgress,
        ),
        RegistrationState(
          email: Email.dirty(tEmail),
          username: Username.dirty(tUsername),
          password: Password.dirty(tPassword),
          passwordRepeat: Password.dirty(tPassword),
          status: FormzStatus.submissionFailure,
        ),
      ],
    );

    blocTest<RegistrationBloc, RegistrationState>(
      'emits [InProgress, Failure] when registration fails',
      setUp: () {
        when(
          () => signUpUseCase.call(any()),
        ).thenAnswer((_) async => Left(ServerFailure()));
      },
      build: () => RegistrationBloc(signUp: signUpUseCase),
      act: (bloc) {
        bloc
          ..add(RegistrationEmailChanged(tEmail))
          ..add(RegistrationUsernameChanged(tUsername))
          ..add(RegistrationPasswordChanged(tPassword))
          ..add(RegistrationPasswordRepeatChanged(tPassword))
          ..add(RegistrationSubmitted());
      },
      expect: () => const <RegistrationState>[
        RegistrationState(
          email: Email.dirty(tEmail),
          status: FormzStatus.invalid,
        ),
        RegistrationState(
          email: Email.dirty(tEmail),
          username: Username.dirty(tUsername),
          status: FormzStatus.invalid,
        ),
        RegistrationState(
          email: Email.dirty(tEmail),
          username: Username.dirty(tUsername),
          password: Password.dirty(tPassword),
          status: FormzStatus.invalid,
        ),
        RegistrationState(
          email: Email.dirty(tEmail),
          username: Username.dirty(tUsername),
          password: Password.dirty(tPassword),
          passwordRepeat: Password.dirty(tPassword),
          status: FormzStatus.valid,
        ),
        RegistrationState(
          email: Email.dirty(tEmail),
          username: Username.dirty(tUsername),
          password: Password.dirty(tPassword),
          passwordRepeat: Password.dirty(tPassword),
          status: FormzStatus.submissionInProgress,
        ),
        RegistrationState(
          email: Email.dirty(tEmail),
          username: Username.dirty(tUsername),
          password: Password.dirty(tPassword),
          passwordRepeat: Password.dirty(tPassword),
          status: FormzStatus.submissionFailure,
        ),
      ],
    );
  });
}
