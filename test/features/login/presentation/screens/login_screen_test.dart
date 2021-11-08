import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:wikiclimb_flutter_frontend/core/widgets/form/decorated_icon_input.dart';
import 'package:mocktail/mocktail.dart';

import 'package:bloc_test/bloc_test.dart';
import 'package:wikiclimb_flutter_frontend/features/login/presentation/bloc/login_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/login/presentation/screens/login_screen.dart';

class MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginBloc {}

class FakeLoginState extends Fake implements LoginState {}

class FakeLoginEvent extends Fake implements LoginEvent {}

void main() {
  late final GetIt sl;
  late final LoginBloc loginBloc;

  setUpAll(() async {
    registerFallbackValue(FakeLoginState());
    registerFallbackValue(FakeLoginEvent());

    sl = GetIt.instance;
    loginBloc = MockLoginBloc();
    sl.registerFactory<LoginBloc>(() => loginBloc);
  });

  group('handles clicks', () {
    setUp(() {
      whenListen(
        loginBloc,
        Stream.fromIterable([LoginInitial()]),
        initialState: LoginInitial(),
      );
    });

    testWidgets(
      'click login pushes LoginRequested state',
      (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
        expect(find.byType(LoginScreen), findsOneWidget);
        await tester.tap(find.byType(ElevatedButton).first);
        await tester.pumpAndSettle();
        verify(
          () => loginBloc.add(
            const LoginRequested(
              username: 'username',
              password: 'password',
            ),
          ),
        ).called(1);
      },
    );
  });

  group(
    'responds to LoginInitial',
    () {
      testWidgets(
        'Login displays',
        (WidgetTester tester) async {
          whenListen(
            loginBloc,
            Stream.fromIterable([LoginInitial()]),
            initialState: LoginInitial(),
          );
          await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
          expect(find.text('Log in'), findsNWidgets(2));
          expect(find.byType(DecoratedIconInput), findsNWidgets(2));
        },
      );

      testWidgets(
        'responds to LoginSuccess',
        (WidgetTester tester) async {
          whenListen(
            loginBloc,
            Stream.fromIterable([LoginSuccess()]),
            initialState: LoginSuccess(),
          );
          await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
          expect(find.text('success'), findsOneWidget);
        },
      );

      testWidgets(
        'responds to LoginError',
        (WidgetTester tester) async {
          whenListen(
            loginBloc,
            Stream.fromIterable([const LoginError(message: 'Error')]),
            initialState: const LoginError(message: 'Error'),
          );
          await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
          expect(find.text('Error'), findsOneWidget);
        },
      );

      testWidgets(
        'responds to LoginError',
        (WidgetTester tester) async {
          whenListen(
            loginBloc,
            Stream.fromIterable([LoginLoading()]),
            initialState: LoginLoading(),
          );
          await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
          expect(find.byType(CircularProgressIndicator), findsOneWidget);
        },
      );
    },
  );
}
