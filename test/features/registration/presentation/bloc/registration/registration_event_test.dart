// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:wikiclimb_flutter_frontend/features/registration/presentation/bloc/registration/registration_bloc.dart';

void main() {
  const tUsername = 'mock-username';
  const tPassword = 'mock-password';
  const tEmail = 'mock-email@example.com';

  group('RegistrationEmailChanged', () {
    test('supports value comparisons', () {
      expect(
        RegistrationEmailChanged(tEmail),
        RegistrationEmailChanged(tEmail),
      );
    });
  });
  group('RegistrationUsernameChanged', () {
    test('supports value comparisons', () {
      expect(
        RegistrationUsernameChanged(tUsername),
        RegistrationUsernameChanged(tUsername),
      );
    });
  });

  group('RegistrationPasswordChanged', () {
    test('supports value comparisons', () {
      expect(
        RegistrationPasswordChanged(tPassword),
        RegistrationPasswordChanged(tPassword),
      );
    });
  });

  group('RegistrationPasswordRepeatChanged', () {
    test('supports value comparisons', () {
      expect(
        RegistrationPasswordRepeatChanged(tPassword),
        RegistrationPasswordRepeatChanged(tPassword),
      );
    });
  });

  group('RegistrationSubmitted', () {
    test('supports value comparisons', () {
      expect(RegistrationSubmitted(), RegistrationSubmitted());
    });
  });
}
