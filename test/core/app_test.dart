import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wikiclimb_flutter_frontend/core/app.dart';
import 'package:mocktail/mocktail.dart';

import 'package:bloc_test/bloc_test.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/home/presentation/screens/home_screen.dart';

class MockAuthenticationBloc
    extends MockBloc<AuthenticationEvent, AuthenticationState>
    implements AuthenticationBloc {}

class FakeAuthenticationEvent extends Fake implements AuthenticationEvent {}

class FakeAuthenticationState extends Fake implements AuthenticationState {}

void main() {
  late final AuthenticationBloc authBloc;

  setUpAll(() {
    registerFallbackValue(FakeAuthenticationEvent());
    registerFallbackValue(FakeAuthenticationState());
  });

  setUp(() {
    authBloc = MockAuthenticationBloc();
  });

  testWidgets('App displays', (WidgetTester tester) async {
    when(() => authBloc.state)
        .thenAnswer((invocation) => AuthenticationUnauthenticated());
    await tester.pumpWidget(
      BlocProvider(
        create: (BuildContext context) => authBloc,
        child: const App(),
      ),
    );
    expect(find.text('WikiClimb'), findsOneWidget);
    expect(find.byType(App), findsOneWidget);
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
