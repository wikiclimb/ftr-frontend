import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import 'package:wikiclimb_flutter_frontend/features/login/presentation/bloc/login_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/login/presentation/screens/login_screen.dart';
import 'package:wikiclimb_flutter_frontend/features/login/presentation/widgets/login_form.dart';

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

  test('is routable', () {
    expect(LoginScreen.route(), isA<MaterialPageRoute>());
  });

  testWidgets('renders a LoginForm', (tester) async {
    when(() => loginBloc.state).thenAnswer((_) => const LoginState());
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: LoginScreen()),
      ),
    );
    expect(find.byType(LoginForm), findsOneWidget);
    await tester.pumpAndSettle();
    // LoginForm is being provided LoginBloc, verify it is used.
    verify(() => loginBloc.state).called(greaterThan(1));
  });
}
