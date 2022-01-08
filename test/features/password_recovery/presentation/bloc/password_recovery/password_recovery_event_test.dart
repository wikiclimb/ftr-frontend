// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:wikiclimb_flutter_frontend/features/password_recovery/presentation/bloc/password_recovery/password_recovery_bloc.dart';

void main() {
  test('value equality', () {
    expect(PasswordRecoveryEvent.started(), PasswordRecoveryEvent.started());
  });

  test('parameters', () {
    const tEmail = 'test@example.com';
    final event = PasswordRecoveryEvent.emailUpdated(tEmail);
    event.maybeWhen(
      emailUpdated: (email) => expect(email, tEmail),
      orElse: () {},
    );
  });
}
