// ignore_for_file: prefer_const_constructors
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wikiclimb_flutter_frontend/features/password_recovery/presentation/bloc/password_recovery/password_recovery_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/password_recovery/presentation/screens/password_recovery_screen.dart';
import 'package:wikiclimb_flutter_frontend/features/password_recovery/presentation/widgets/password_recovery_form.dart';

class MockPasswordRecoveryBloc
    extends MockBloc<PasswordRecoveryEvent, PasswordRecoveryState>
    implements PasswordRecoveryBloc {}

class FakePasswordRecoveryState extends Fake implements PasswordRecoveryState {}

class FakePasswordRecoveryEvent extends Fake implements PasswordRecoveryEvent {}

void main() {
  late final GetIt sl;
  late final PasswordRecoveryBloc passwordRecoveryBloc;

  setUpAll(() async {
    registerFallbackValue(FakePasswordRecoveryState());
    registerFallbackValue(FakePasswordRecoveryEvent());

    sl = GetIt.instance;
    passwordRecoveryBloc = MockPasswordRecoveryBloc();
    sl.registerFactory<PasswordRecoveryBloc>(() => passwordRecoveryBloc);
  });

  test('is routable', () {
    expect(PasswordRecoveryScreen.route(), isA<MaterialPageRoute>());
  });

  testWidgets('renders a password recovery form', (tester) async {
    when(() => passwordRecoveryBloc.state)
        .thenAnswer((_) => PasswordRecoveryState());
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: PasswordRecoveryScreen(),
        ),
      ),
    );
    expect(find.byType(PasswordRecoveryForm), findsOneWidget);
    await tester.pumpAndSettle();
    verify(() => passwordRecoveryBloc.state).called(greaterThan(1));
  });
}
