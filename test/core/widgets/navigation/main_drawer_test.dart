// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wikiclimb_flutter_frontend/core/widgets/navigation/main_drawer.dart';
import 'package:wikiclimb_flutter_frontend/features/area/presentation/screens/area_list_screen.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/entities/authentication_data.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/home/presentation/screens/home_screen.dart';
import 'package:wikiclimb_flutter_frontend/features/login/presentation/screens/login_screen.dart';
import 'package:wikiclimb_flutter_frontend/features/login/presentation/widgets/login_drawer_tile.dart';
import 'package:wikiclimb_flutter_frontend/features/map/presentation/screens/map_screen.dart';
import 'package:wikiclimb_flutter_frontend/features/registration/presentation/screens/registration_screen.dart';

extension on WidgetTester {
  Future<void> pumpIt(AuthenticationBloc mockAuthBloc, String currentRoute) =>
      pumpWidget(
        BlocProvider<AuthenticationBloc>(
          create: (BuildContext context) => mockAuthBloc,
          child: MaterialApp(
            home: Scaffold(
              body: MainDrawer(
                currentRoute: currentRoute,
              ),
            ),
            routes: {
              AreaListScreen.id: (context) => MockAreaListScreen(),
              RegistrationScreen.id: (context) => MockRegistrationScreen(),
              MapScreen.id: (context) => MockMapScreen(),
            },
          ),
        ),
      );
}

class MockAuthenticationBloc extends MockCubit<AuthenticationState>
    implements AuthenticationBloc {}

class FakeAuthenticationState extends Fake implements AuthenticationState {}

void main() {
  late final MockAuthenticationBloc authBloc;
  const tAuthData = AuthenticationData(
    token: 'token',
    id: 123,
    username: 'test-username',
  );

  setUpAll(() async {
    registerFallbackValue(FakeAuthenticationState());
    authBloc = MockAuthenticationBloc();
  });

  testWidgets(
    'displays login tile when not in login screen',
    (WidgetTester tester) async {
      whenListen(
        authBloc,
        Stream.fromIterable([
          const AuthenticationAuthenticated(tAuthData),
        ]),
        initialState: AuthenticationInitial(),
      );
      await tester.pumpIt(authBloc, HomeScreen.id);
      expect(find.byType(LoginDrawerTile), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
    },
  );

  testWidgets(
    'does not display login tile when in login screen',
    (WidgetTester tester) async {
      whenListen(
        authBloc,
        Stream.fromIterable([
          const AuthenticationAuthenticated(tAuthData),
        ]),
        initialState: AuthenticationInitial(),
      );
      await tester.pumpIt(authBloc, LoginScreen.id);
      expect(find.byType(LoginDrawerTile), findsNothing);
    },
  );

  testWidgets(
    'displays area tile',
    (WidgetTester tester) async {
      whenListen(
        authBloc,
        Stream.fromIterable([
          const AuthenticationAuthenticated(tAuthData),
        ]),
        initialState: AuthenticationInitial(),
      );
      await tester.pumpIt(authBloc, LoginScreen.id);
      expect(find.text('Areas'), findsOneWidget);
      await tester.tap(find.text('Areas'));
    },
  );

  group('registration tile', () {
    testWidgets(
      'displays when not authenticated',
      (WidgetTester tester) async {
        when(() => authBloc.state)
            .thenAnswer((_) => AuthenticationUnauthenticated());
        await tester.pumpIt(authBloc, LoginScreen.id);
        expect(
          find.byKey(Key('mainDrawer_registrationDrawerTile')),
          findsOneWidget,
        );
        expect(find.text('Sign Up'), findsOneWidget);
        await tester.tap(find.text('Sign Up'));
        await tester.pumpAndSettle();
        expect(find.byType(MockRegistrationScreen), findsOneWidget);
      },
    );

    testWidgets(
      'does not display when on registration route',
      (WidgetTester tester) async {
        when(() => authBloc.state)
            .thenAnswer((_) => AuthenticationUnauthenticated());
        await tester.pumpIt(authBloc, RegistrationScreen.id);
        expect(find.text('Sign Up'), findsNothing);
      },
    );

    testWidgets(
      'does not display when already authenticated',
      (WidgetTester tester) async {
        when(() => authBloc.state)
            .thenAnswer((_) => AuthenticationAuthenticated(tAuthData));
        await tester.pumpIt(authBloc, LoginScreen.id);
        expect(
          find.byKey(Key('mainDrawer_registrationDrawerTile')),
          findsNothing,
        );
        expect(find.text('Sign Up'), findsNothing);
      },
    );
  });

  group('map tile', () {
    testWidgets(
      'is visible and navigates to map screen on tap',
      (WidgetTester tester) async {
        when(() => authBloc.state)
            .thenAnswer((_) => AuthenticationUnauthenticated());
        await tester.pumpIt(authBloc, LoginScreen.id);
        expect(
          find.byKey(Key('mainDrawer_mapDrawerTile')),
          findsOneWidget,
        );
        final finder = find.text('Map');
        expect(finder, findsOneWidget);
        expect(find.byIcon(Icons.map), findsOneWidget);
        await tester.tap(finder);
        await tester.pumpAndSettle();
        expect(find.byType(MockMapScreen), findsOneWidget);
      },
    );

    testWidgets(
      'is not visible when in map route',
      (WidgetTester tester) async {
        when(() => authBloc.state)
            .thenAnswer((_) => AuthenticationUnauthenticated());
        await tester.pumpIt(authBloc, MapScreen.id);
        expect(find.byKey(Key('mainDrawer_mapDrawerTile')), findsNothing);
      },
    );
  });
}

class MockAreaListScreen extends StatelessWidget {
  const MockAreaListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Mock areas Screen'),
    );
  }
}

class MockRegistrationScreen extends StatelessWidget {
  const MockRegistrationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Mock Registration Screen'),
    );
  }
}

class MockMapScreen extends StatelessWidget {
  const MockMapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Mock Map Screen'),
    );
  }
}
