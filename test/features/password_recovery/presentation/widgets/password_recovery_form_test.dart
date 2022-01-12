// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wikiclimb_flutter_frontend/features/password_recovery/presentation/bloc/password_recovery/password_recovery_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/password_recovery/presentation/widgets/password_recovery_form.dart';

extension on WidgetTester {
  Future<void> pumpIt(PasswordRecoveryBloc mockPasswordRecoveryBloc) {
    return pumpWidget(
      MaterialApp(
          home: Scaffold(
        body: BlocProvider<PasswordRecoveryBloc>(
          create: (context) => mockPasswordRecoveryBloc,
          child: PasswordRecoveryForm(),
        ),
      )),
    );
  }
}

class MockPasswordRecoveryBloc
    extends MockBloc<PasswordRecoveryEvent, PasswordRecoveryState>
    implements PasswordRecoveryBloc {}

void main() {
  late PasswordRecoveryBloc mockPasswordRecoveryBloc;
  const tEmail = 'someone@example.com';

  setUpAll(() {
    mockPasswordRecoveryBloc = MockPasswordRecoveryBloc();
  });

  group('initial', () {
    setUp(() {
      when(() => mockPasswordRecoveryBloc.state)
          .thenAnswer((_) => PasswordRecoveryState());
    });

    testWidgets('renders', (tester) async {
      await tester.pumpIt(mockPasswordRecoveryBloc);
      expect(find.byType(PasswordRecoveryForm), findsOneWidget);
    });
  });

  group('user input', () {
    testWidgets('adds EmailChanged to Bloc when email is updated',
        (tester) async {
      when(() => mockPasswordRecoveryBloc.state)
          .thenReturn(PasswordRecoveryState());
      await tester.pumpIt(mockPasswordRecoveryBloc);
      await tester.enterText(
        find.byKey(const Key('passwordRecoveryForm_emailInput_textField')),
        tEmail,
      );
      verify(
        () => mockPasswordRecoveryBloc
            .add(PasswordRecoveryEvent.emailUpdated(tEmail)),
      ).called(1);
    });
  });

  group('feedback', () {
    testWidgets(
        'loading indicator is shown when status is submission in progress',
        (tester) async {
      when(() => mockPasswordRecoveryBloc.state).thenReturn(
        PasswordRecoveryState(status: FormzStatus.submissionInProgress),
      );
      await tester.pumpIt(mockPasswordRecoveryBloc);
      expect(
        find.byKey(const Key('passwordRecoveryForm_continue_raisedButton')),
        findsNothing,
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows SnackBar when status is submission failure',
        (tester) async {
      whenListen(
        mockPasswordRecoveryBloc,
        Stream.fromIterable([
          PasswordRecoveryState(status: FormzStatus.submissionInProgress),
          PasswordRecoveryState(status: FormzStatus.submissionFailure),
        ]),
      );
      when(() => mockPasswordRecoveryBloc.state).thenReturn(
        PasswordRecoveryState(status: FormzStatus.submissionFailure),
      );
      await tester.pumpIt(mockPasswordRecoveryBloc);
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('continue button is disabled by default', (tester) async {
      when(() => mockPasswordRecoveryBloc.state)
          .thenReturn(PasswordRecoveryState());
      await tester.pumpIt(mockPasswordRecoveryBloc);
      final button = tester.widget<ElevatedButton>(
        find.byKey(Key('passwordRecoveryForm_continue_raisedButton')),
      );
      expect(button.enabled, isFalse);
    });

    testWidgets('continue button is enabled when status is validated',
        (tester) async {
      when(() => mockPasswordRecoveryBloc.state).thenReturn(
        PasswordRecoveryState(status: FormzStatus.valid),
      );
      await tester.pumpIt(mockPasswordRecoveryBloc);
      final button = tester.widget<ElevatedButton>(
        find.byKey(Key('passwordRecoveryForm_continue_raisedButton')),
      );
      expect(button.enabled, isTrue);
    });
  });

  group('events', () {
    testWidgets('Submitted is added to Bloc when continue is tapped',
        (tester) async {
      when(() => mockPasswordRecoveryBloc.state).thenReturn(
        PasswordRecoveryState(status: FormzStatus.valid),
      );
      await tester.pumpIt(mockPasswordRecoveryBloc);
      await tester.tap(
        find.byKey(Key('passwordRecoveryForm_continue_raisedButton')),
      );
      verify(() => mockPasswordRecoveryBloc.add(PasswordRecoveryEvent.submit()))
          .called(1);
    });

    testWidgets('shows snackbar on successful password_recovery',
        (tester) async {
      whenListen(
        mockPasswordRecoveryBloc,
        Stream.fromIterable([
          PasswordRecoveryState(status: FormzStatus.submissionInProgress),
          PasswordRecoveryState(status: FormzStatus.submissionSuccess),
        ]),
      );
      when(() => mockPasswordRecoveryBloc.state).thenReturn(
        PasswordRecoveryState(status: FormzStatus.submissionSuccess),
      );
      await tester.pumpIt(mockPasswordRecoveryBloc);
      expect(
        find.byKey(
          Key('passwordRecoveryForm_successSubmissionConfirmation_text'),
        ),
        findsOneWidget,
      );
    });
  });
}
