// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:wikiclimb_flutter_frontend/core/entities/form_input/email.dart';
import 'package:wikiclimb_flutter_frontend/features/password_recovery/presentation/bloc/password_recovery/password_recovery_bloc.dart';

void main() {
  test('value comparisons', () {
    expect(PasswordRecoveryState(), PasswordRecoveryState());
  });

  test('empty copy with', () {
    expect(PasswordRecoveryState().copyWith(), PasswordRecoveryState());
  });

  test('default values', () {
    final state = PasswordRecoveryState();
    expect(state.status, FormzStatus.pure);
    expect(state.email, Email.pure());
  });
}
