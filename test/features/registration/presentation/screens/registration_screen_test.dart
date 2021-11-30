// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wikiclimb_flutter_frontend/features/registration/presentation/bloc/registration/registration_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/registration/presentation/screens/registration_screen.dart';
import 'package:wikiclimb_flutter_frontend/features/registration/presentation/widgets/registration_form.dart';

class MockRegistrationBloc
    extends MockBloc<RegistrationEvent, RegistrationState>
    implements RegistrationBloc {}

class FakeLoginState extends Fake implements RegistrationState {}

class FakeLoginEvent extends Fake implements RegistrationEvent {}

void main() {
  late final GetIt sl;
  late final RegistrationBloc registrationBloc;

  setUpAll(() async {
    registerFallbackValue(FakeLoginState());
    registerFallbackValue(FakeLoginEvent());

    sl = GetIt.instance;
    registrationBloc = MockRegistrationBloc();
    sl.registerFactory<RegistrationBloc>(() => registrationBloc);
  });

  test('is routable', () {
    expect(RegistrationScreen.route(), isA<MaterialPageRoute>());
  });

  testWidgets('renders a registration form', (tester) async {
    when(() => registrationBloc.state).thenAnswer((_) => RegistrationState());
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: RegistrationScreen()),
      ),
    );
    expect(find.byType(RegistrationForm), findsOneWidget);
    await tester.pumpAndSettle();
    // LoginForm is being provided LoginBloc, verify it is used.
    verify(() => registrationBloc.state).called(greaterThan(1));
  });
}
