// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wikiclimb_flutter_frontend/features/registration/presentation/bloc/registration/registration_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/registration/presentation/widgets/registration_form.dart';

extension on WidgetTester {
  Future<void> pumpIt(RegistrationBloc mockRegistrationBloc) {
    return pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: BlocProvider<RegistrationBloc>(
            create: (context) => mockRegistrationBloc,
            child: RegistrationForm(),
          ),
        ),
      ),
    );
  }
}

class MockRegistrationBloc
    extends MockBloc<RegistrationEvent, RegistrationState>
    implements RegistrationBloc {}

void main() {
  late RegistrationBloc mockRegistrationBloc;
  const tUsername = 'username';
  const tEmail = 'someone@example.com';
  const tPassword = 'very-secret';

  setUpAll(() {
    mockRegistrationBloc = MockRegistrationBloc();
  });

  group('initial', () {
    setUp(() {
      when(() => mockRegistrationBloc.state)
          .thenAnswer((_) => RegistrationState());
    });

    testWidgets('renders', (tester) async {
      await tester.pumpIt(mockRegistrationBloc);
      expect(find.byType(RegistrationForm), findsOneWidget);
    });
  });

  group('user input', () {
    testWidgets('adds EmailChanged to Bloc when email is updated',
        (tester) async {
      when(() => mockRegistrationBloc.state).thenReturn(RegistrationState());
      await tester.pumpIt(mockRegistrationBloc);
      await tester.enterText(
        find.byKey(const Key('registrationForm_emailInput_textField')),
        tEmail,
      );
      verify(
        () => mockRegistrationBloc.add(const RegistrationEmailChanged(tEmail)),
      ).called(1);
    });

    testWidgets('adds UsernameChanged to Bloc when username is updated',
        (tester) async {
      when(() => mockRegistrationBloc.state).thenReturn(RegistrationState());
      await tester.pumpIt(mockRegistrationBloc);
      await tester.enterText(
        find.byKey(const Key('registrationForm_usernameInput_textField')),
        tUsername,
      );
      verify(
        () => mockRegistrationBloc
            .add(const RegistrationUsernameChanged(tUsername)),
      ).called(1);
    });

    testWidgets('adds PasswordChanged to Bloc when password is updated',
        (tester) async {
      when(() => mockRegistrationBloc.state).thenReturn(RegistrationState());
      await tester.pumpIt(mockRegistrationBloc);
      await tester.enterText(
        find.byKey(const Key('registrationForm_passwordInput_textField')),
        tPassword,
      );
      verify(
        () => mockRegistrationBloc
            .add(const RegistrationPasswordChanged(tPassword)),
      ).called(1);
    });

    testWidgets(
        'adds PasswordRepeatChanged to Bloc when password repeat is updated',
        (tester) async {
      when(() => mockRegistrationBloc.state).thenReturn(RegistrationState());
      await tester.pumpIt(mockRegistrationBloc);
      await tester.enterText(
        find.byKey(const Key('registrationForm_passwordRepeatInput_textField')),
        tPassword,
      );
      verify(
        () => mockRegistrationBloc
            .add(const RegistrationPasswordRepeatChanged(tPassword)),
      ).called(1);
    });
  });

  group('feedback', () {
    testWidgets(
        'loading indicator is shown when status is submission in progress',
        (tester) async {
      when(() => mockRegistrationBloc.state).thenReturn(
        const RegistrationState(status: FormzStatus.submissionInProgress),
      );
      await tester.pumpIt(mockRegistrationBloc);
      expect(
        find.byKey(const Key('registrationForm_continue_raisedButton')),
        findsNothing,
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows SnackBar when status is submission failure',
        (tester) async {
      whenListen(
        mockRegistrationBloc,
        Stream.fromIterable([
          const RegistrationState(status: FormzStatus.submissionInProgress),
          const RegistrationState(status: FormzStatus.submissionFailure),
        ]),
      );
      when(() => mockRegistrationBloc.state).thenReturn(
        const RegistrationState(status: FormzStatus.submissionFailure),
      );
      await tester.pumpIt(mockRegistrationBloc);
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('continue button is disabled by default', (tester) async {
      when(() => mockRegistrationBloc.state).thenReturn(RegistrationState());
      await tester.pumpIt(mockRegistrationBloc);
      final button = tester.widget<ElevatedButton>(
        find.byKey(Key('registrationForm_continue_raisedButton')),
      );
      expect(button.enabled, isFalse);
    });

    testWidgets('continue button is enabled when status is validated',
        (tester) async {
      when(() => mockRegistrationBloc.state).thenReturn(
        RegistrationState(status: FormzStatus.valid),
      );
      await tester.pumpIt(mockRegistrationBloc);
      final button = tester.widget<ElevatedButton>(
        find.byKey(Key('registrationForm_continue_raisedButton')),
      );
      expect(button.enabled, isTrue);
    });
  });

  group('events', () {
    testWidgets('Submitted is added to Bloc when continue is tapped',
        (tester) async {
      when(() => mockRegistrationBloc.state).thenReturn(
        RegistrationState(status: FormzStatus.valid),
      );
      await tester.pumpIt(mockRegistrationBloc);
      await tester.tap(
        find.byKey(Key('registrationForm_continue_raisedButton')),
      );
      verify(() => mockRegistrationBloc.add(RegistrationSubmitted())).called(1);
    });

    testWidgets('shows dialog on successful registration', (tester) async {
      whenListen(
        mockRegistrationBloc,
        Stream.fromIterable([
          RegistrationState(status: FormzStatus.submissionInProgress),
          RegistrationState(status: FormzStatus.submissionSuccess),
        ]),
      );
      when(() => mockRegistrationBloc.state).thenReturn(
        RegistrationState(status: FormzStatus.submissionSuccess),
      );
      await tester.pumpIt(mockRegistrationBloc);
      expect(
        find.byKey(
          Key('registrationScreen_successfulSubmissionConfirmation_text'),
        ),
        findsOneWidget,
      );
    });
  });
}
