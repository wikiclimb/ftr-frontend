import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wikiclimb_flutter_frontend/core/widgets/form/decorated_icon_input.dart';

import 'package:wikiclimb_flutter_frontend/features/login/presentation/bloc/login_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/login/presentation/widgets/login_form.dart';

class MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginBloc {}

class FakeLoginState extends Fake implements LoginState {}

class FakeLoginEvent extends Fake implements LoginEvent {}

void main() {
  late final LoginBloc loginBloc;

  setUpAll(() async {
    registerFallbackValue(FakeLoginState());
    registerFallbackValue(FakeLoginEvent());

    loginBloc = MockLoginBloc();
  });
  group('sends fields content to bloc call', () {
    const tUsername = 'lgf-test-username';
    const tPassword = 'lgf-test-password';

    testWidgets(
      'should pass field values to bloc',
      (WidgetTester tester) async {
        await pumpLoginForm(tester, loginBloc);
        final usernameInput = find.byKey(const Key('username-input'));
        final passwordInput = find.byKey(const Key('password-input'));
        final loginButton = find.byKey(const Key('login-button'));
        expect(usernameInput, findsOneWidget);
        expect(passwordInput, findsOneWidget);
        expect(loginButton, findsOneWidget);
        await tester.enterText(usernameInput, tUsername);
        await tester.enterText(passwordInput, tPassword);
        await tester.tap(loginButton);
        verify(
          () => loginBloc.add(
            const LoginRequested(
              username: tUsername,
              password: tPassword,
            ),
          ),
        ).called(1);
        verifyNoMoreInteractions(loginBloc);
      },
    );
  });

  group('handles authentication initial state', () {
    setUp(() {
      whenListen(
        loginBloc,
        Stream.fromIterable([LoginInitial()]),
        initialState: LoginInitial(),
      );
    });
    testWidgets('fields should display', (WidgetTester tester) async {
      await pumpLoginForm(tester, loginBloc);
      expect(find.byType(DecoratedIconInput), findsNWidgets(2));
    });
  });

  group('handles authentication loading state', () {});
  group('handles authentication success state', () {});
  group('handles authentication failed state', () {});
}

Future<void> pumpLoginForm(
  WidgetTester tester,
  LoginBloc loginBloc,
) async {
  await tester.pumpWidget(
    MaterialApp(
      home: BlocProvider<LoginBloc>(
        create: (BuildContext context) => loginBloc,
        child: const Scaffold(
          body: LoginForm(),
        ),
      ),
    ),
  );
}
