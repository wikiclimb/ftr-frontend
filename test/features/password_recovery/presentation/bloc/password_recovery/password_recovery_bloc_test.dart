// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wikiclimb_flutter_frontend/core/entities/form_input/email.dart';
import 'package:wikiclimb_flutter_frontend/core/entities/response.dart';
import 'package:wikiclimb_flutter_frontend/core/utils/validator.dart';
import 'package:wikiclimb_flutter_frontend/features/password_recovery/domain/entities/password_recovery_params.dart';
import 'package:wikiclimb_flutter_frontend/features/password_recovery/domain/usecases/request_password_recovery_email.dart';
import 'package:wikiclimb_flutter_frontend/features/password_recovery/presentation/bloc/password_recovery/password_recovery_bloc.dart';

class MockRequestPasswordRecoveryEmail extends Mock
    implements RequestPasswordRecoveryEmail {}

void main() {
  late MockRequestPasswordRecoveryEmail usecase;
  late PasswordRecoveryBloc bloc;
  const tEmail = 'test@example.com';
  final params = PasswordRecoveryParams(email: tEmail);
  final successResponse = Response((r) => r
    ..error = false
    ..message = 'OK');

  setUp(() {
    usecase = MockRequestPasswordRecoveryEmail();
    bloc = PasswordRecoveryBloc(requestPasswordRecoveryEmailUseCase: usecase);
  });

  test('initial state should be clean', () {
    expect(bloc.state, PasswordRecoveryState());
  });

  group('submission requested', () {
    final state1 = PasswordRecoveryState(
      email: Email.dirty('test'),
      status: FormzStatus.invalid,
    );
    final state2 = state1.copyWith(
      status: FormzStatus.valid,
      email: Email.dirty(tEmail),
    );
    final state3 = state2.copyWith(status: FormzStatus.submissionInProgress);
    final state4 = state3.copyWith(status: FormzStatus.submissionSuccess);

    blocTest<PasswordRecoveryBloc, PasswordRecoveryState>(
      'success result',
      setUp: () {
        when(() => usecase(params))
            .thenAnswer((_) async => Right(successResponse));
      },
      build: () => PasswordRecoveryBloc(
        requestPasswordRecoveryEmailUseCase: usecase,
      ),
      act: (bloc) {
        bloc
          ..add(PasswordRecoveryEvent.emailUpdated('test'))
          ..add(PasswordRecoveryEvent.emailUpdated(tEmail))
          ..add(PasswordRecoveryEvent.submit());
      },
      expect: () => <PasswordRecoveryState>[state1, state2, state3, state4],
      verify: (bloc) {
        verify(() => usecase(params)).called(1);
        verifyNoMoreInteractions(usecase);
      },
    );

    final state4Failed = state3.copyWith(status: FormzStatus.submissionFailure);

    blocTest<PasswordRecoveryBloc, PasswordRecoveryState>(
      'failure result',
      setUp: () {
        when(() => usecase(params)).thenAnswer(
            (_) async => Left(ValidationFailure('Email not found')));
      },
      build: () => PasswordRecoveryBloc(
        requestPasswordRecoveryEmailUseCase: usecase,
      ),
      act: (bloc) {
        bloc
          ..add(PasswordRecoveryEvent.emailUpdated('test'))
          ..add(PasswordRecoveryEvent.emailUpdated(tEmail))
          ..add(PasswordRecoveryEvent.submit());
      },
      expect: () =>
          <PasswordRecoveryState>[state1, state2, state3, state4Failed],
      verify: (bloc) {
        verify(() => usecase(params)).called(1);
        verifyNoMoreInteractions(usecase);
      },
    );

    blocTest<PasswordRecoveryBloc, PasswordRecoveryState>(
      'exception',
      setUp: () {
        when(() => usecase(params)).thenThrow(Exception());
      },
      build: () => PasswordRecoveryBloc(
        requestPasswordRecoveryEmailUseCase: usecase,
      ),
      act: (bloc) {
        bloc
          ..add(PasswordRecoveryEvent.emailUpdated('test'))
          ..add(PasswordRecoveryEvent.emailUpdated(tEmail))
          ..add(PasswordRecoveryEvent.submit());
      },
      expect: () =>
          <PasswordRecoveryState>[state1, state2, state3, state4Failed],
      verify: (bloc) {
        verify(() => usecase(params)).called(1);
        verifyNoMoreInteractions(usecase);
      },
    );
  });
}
