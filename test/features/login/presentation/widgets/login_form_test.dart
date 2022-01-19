// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wikiclimb_flutter_frontend/features/home/presentation/screens/home_screen.dart';
import 'package:wikiclimb_flutter_frontend/features/login/presentation/bloc/login_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/login/presentation/widgets/login_form.dart';
import 'package:wikiclimb_flutter_frontend/features/password_recovery/presentation/bloc/password_recovery/password_recovery_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/password_recovery/presentation/widgets/password_recovery_form.dart';

class FakeLoginEvent extends Fake implements LoginEvent {}

class FakeLoginState extends Fake implements LoginState {}

class MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginBloc {}

class MockPasswordRecoveryBloc
    extends MockBloc<PasswordRecoveryEvent, PasswordRecoveryState>
    implements PasswordRecoveryBloc {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class FakeRoute extends Fake implements MaterialPageRoute {}

extension on WidgetTester {
  Future<void> pumpIt(LoginBloc loginBloc) => pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: BlocProvider.value(
              value: loginBloc,
              child: const LoginForm(),
            ),
          ),
        ),
      );
}

void main() {
  late LoginBloc loginBloc;

  setUpAll(() {
    registerFallbackValue(FakeLoginEvent());
    registerFallbackValue(FakeLoginState());
    registerFallbackValue(FakeRoute());
  });

  setUp(() {
    loginBloc = MockLoginBloc();
  });

  testWidgets('adds LoginUsernameChanged to LoginBloc when username is updated',
      (tester) async {
    const username = 'username';
    when(() => loginBloc.state).thenReturn(const LoginState());
    await tester.pumpIt(loginBloc);
    await tester.enterText(
      find.byKey(const Key('loginForm_usernameInput_textField')),
      username,
    );
    verify(
      () => loginBloc.add(const LoginUsernameChanged(username)),
    ).called(1);
  });

  testWidgets('adds LoginPasswordChanged to LoginBloc when password is updated',
      (tester) async {
    const password = 'password';
    when(() => loginBloc.state).thenReturn(LoginState());
    await tester.pumpIt(loginBloc);
    await tester.enterText(
      find.byKey(Key('loginForm_passwordInput_textField')),
      password,
    );
    verify(
      () => loginBloc.add(LoginPasswordChanged(password)),
    ).called(1);
  });

  testWidgets('continue button is disabled by default', (tester) async {
    when(() => loginBloc.state).thenReturn(LoginState());
    await tester.pumpIt(loginBloc);
    final button = tester.widget<ElevatedButton>(
      find.byKey(Key('loginForm_continue_raisedButton')),
    );
    expect(button.enabled, isFalse);
  });

  testWidgets(
      'loading indicator is shown when status is submission in progress',
      (tester) async {
    when(() => loginBloc.state).thenReturn(
      LoginState(
        status: FormzStatus.submissionInProgress,
      ),
    );
    await tester.pumpIt(loginBloc);
    expect(
      find.byKey(Key('loginForm_continue_raisedButton')),
      findsNothing,
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('continue button is enabled when status is validated',
      (tester) async {
    when(() => loginBloc.state).thenReturn(
      const LoginState(status: FormzStatus.valid),
    );
    await tester.pumpIt(loginBloc);
    final button = tester.widget<ElevatedButton>(
      find.byKey(Key('loginForm_continue_raisedButton')),
    );
    expect(button.enabled, isTrue);
  });

  testWidgets('LoginSubmitted is added to LoginBloc when continue is tapped',
      (tester) async {
    when(() => loginBloc.state).thenReturn(
      LoginState(status: FormzStatus.valid),
    );
    await tester.pumpIt(loginBloc);
    await tester.tap(
      find.byKey(Key('loginForm_continue_raisedButton')),
    );
    verify(() => loginBloc.add(LoginSubmitted())).called(1);
  });

  testWidgets('shows SnackBar when status is submission failure',
      (tester) async {
    whenListen(
      loginBloc,
      Stream.fromIterable([
        LoginState(status: FormzStatus.submissionInProgress),
        LoginState(status: FormzStatus.submissionFailure),
      ]),
    );
    when(() => loginBloc.state).thenReturn(
      LoginState(status: FormzStatus.submissionFailure),
    );
    await tester.pumpIt(loginBloc);
    await tester.pump();
    expect(find.byType(SnackBar), findsOneWidget);
  });

  testWidgets('navigates to HomeScreen on successful login', (tester) async {
    final NavigatorObserver mockObserver = MockNavigatorObserver();
    whenListen(
      loginBloc,
      Stream.fromIterable([
        LoginState(status: FormzStatus.submissionInProgress),
        LoginState(status: FormzStatus.submissionSuccess),
      ]),
    );
    when(() => loginBloc.state).thenReturn(
      LoginState(status: FormzStatus.submissionSuccess),
    );
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        navigatorObservers: [mockObserver],
        initialRoute: MockLoginScreen.id,
        routes: {
          MockLoginScreen.id: (context) =>
              MockLoginScreen(loginBloc: loginBloc),
          HomeScreen.id: (context) => MockHomeScreen(),
        },
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(MockHomeScreen), findsOneWidget);
  });

  group('navigation to password recovery', () {
    final sl = GetIt.instance;
    late PasswordRecoveryBloc mockPasswordRecoveryBloc;

    setUp(() {
      mockPasswordRecoveryBloc = MockPasswordRecoveryBloc();
      when(() => mockPasswordRecoveryBloc.state)
          .thenAnswer((_) => PasswordRecoveryState());
      sl.registerSingletonAsync<PasswordRecoveryBloc>(
        () async => mockPasswordRecoveryBloc,
      );
    });

    testWidgets('navigates to PasswordRecoveryScreen on button click',
        (tester) async {
      when(() => loginBloc.state).thenReturn(LoginState());
      await tester.pumpIt(loginBloc);
      final finder = find.byKey(Key('loginForm_passwordReset_elevatedButton'));
      expect(finder, findsOneWidget);
      await tester.tap(finder);
      await tester.pumpAndSettle();
      expect(find.byType(PasswordRecoveryForm), findsOneWidget);
    });
  });
}

class MockHomeScreen extends StatelessWidget {
  const MockHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Mock HomeScreen'),
    );
  }
}

class MockLoginScreen extends StatelessWidget {
  const MockLoginScreen({Key? key, required this.loginBloc}) : super(key: key);

  static const id = '/mock-login';
  final LoginBloc loginBloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider.value(
        value: loginBloc,
        child: const LoginForm(),
      ),
    );
  }
}
