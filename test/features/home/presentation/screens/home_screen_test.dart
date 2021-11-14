import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:bloc_test/bloc_test.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/entities/authentication_data.dart';
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
    authBloc = MockAuthenticationBloc();
  });

  testWidgets('HomeScreen displays', (WidgetTester tester) async {
    when(() => authBloc.state)
        .thenAnswer((_) => AuthenticationUnauthenticated());
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider(
            create: (BuildContext context) => authBloc,
            child: const HomeScreen(),
          ),
        ),
      ),
    );
    expect(find.text('Hello guest'), findsOneWidget);
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('HomeScreen displays', (WidgetTester tester) async {
    const tAuthData = AuthenticationData(
      token: 'token',
      id: 123,
      username: 'test-username',
    );
    when(() => authBloc.state).thenAnswer(
      (_) => const AuthenticationAuthenticated(tAuthData),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider(
            create: (BuildContext context) => authBloc,
            child: const HomeScreen(),
          ),
        ),
      ),
    );
    expect(find.text('Hello test-username'), findsOneWidget);
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
