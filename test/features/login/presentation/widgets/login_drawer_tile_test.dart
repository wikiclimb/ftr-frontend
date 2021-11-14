import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/entities/authentication_data.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/home/presentation/screens/home_screen.dart';
import 'package:wikiclimb_flutter_frontend/features/login/presentation/bloc/login_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/login/presentation/screens/login_screen.dart';
import 'package:wikiclimb_flutter_frontend/features/login/presentation/widgets/login_drawer_tile.dart';

class MockAuthenticationBloc extends MockCubit<AuthenticationState>
    implements AuthenticationBloc {}

class MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginBloc {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class FakeAuthenticationState extends Fake implements AuthenticationState {}

class FakeLoginState extends Fake implements LoginState {}

class FakeLoginEvent extends Fake implements LoginEvent {}

void main() {
  late final GetIt sl;
  late final MockAuthenticationBloc authBloc;
  late final LoginBloc loginBloc;
  const tAuthData = AuthenticationData(
    token: 'token',
    id: 123,
    username: 'test-username',
  );

  setUpAll(() async {
    sl = GetIt.instance;
    registerFallbackValue(FakeAuthenticationState());
    registerFallbackValue(FakeLoginState());
    registerFallbackValue(FakeLoginEvent());

    authBloc = MockAuthenticationBloc();
    loginBloc = MockLoginBloc();

    sl.registerFactory<LoginBloc>(() => loginBloc);
  });

  testWidgets(
    'displays login tile when authentication data is not present',
    (WidgetTester tester) async {
      when(() => authBloc.state).thenAnswer((_) => AuthenticationInitial());
      await pumpLoginDrawer(tester, authBloc);
      expect(find.byType(LoginTile), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
    },
  );

  testWidgets(
    'displays logout tile when authentication data is present',
    (WidgetTester tester) async {
      when(() => authBloc.state)
          .thenAnswer((_) => const AuthenticationAuthenticated(tAuthData));
      await pumpLoginDrawer(tester, authBloc);
      expect(find.byType(LogoutTile), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);
    },
  );

  testWidgets(
    'displays login tile when authentication data is loading',
    (WidgetTester tester) async {
      when(() => authBloc.state).thenAnswer((_) => AuthenticationInitial());
      await pumpLoginDrawer(tester, authBloc);
      expect(find.byType(LoginTile), findsOneWidget);
    },
  );

  group('test navigation events', () {
    late final MockNavigatorObserver mockNavigatorObserver;
    setUp(() {
      mockNavigatorObserver = MockNavigatorObserver();
    });

    testWidgets(
      'login tile navigates to login screen',
      (WidgetTester tester) async {
        when(() => loginBloc.state).thenAnswer((_) => const LoginState());
        when(() => authBloc.state).thenAnswer((_) => AuthenticationInitial());
        await tester.pumpWidget(
          MaterialApp(
            navigatorObservers: [mockNavigatorObserver],
            initialRoute: HomeScreen.id,
            routes: {
              HomeScreen.id: (context) => MockHomeScreen(authBloc: authBloc),
              LoginScreen.id: (context) => const MockLoginScreen(),
            },
          ),
        );
        expect(find.byType(LoginTile), findsOneWidget);
        expect(find.text('Login'), findsOneWidget);
        await tester.tap(find.text('Login'));
        await tester.pumpAndSettle();
        expect(find.text('Login Screen'), findsOneWidget);
      },
    );
  });
}

Future<void> pumpLoginDrawer(
  WidgetTester tester,
  AuthenticationBloc authBloc,
) async {
  await tester.pumpWidget(
    MaterialApp(
      home: BlocProvider<AuthenticationBloc>(
        create: (BuildContext context) => authBloc,
        child: const Scaffold(
          body: LoginDrawerTile(),
        ),
      ),
    ),
  );
}

class MockHomeScreen extends StatelessWidget {
  const MockHomeScreen({
    Key? key,
    required this.authBloc,
  }) : super(key: key);

  final AuthenticationBloc authBloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      create: (BuildContext context) => authBloc,
      child: const Scaffold(
        body: LoginDrawerTile(),
      ),
    );
  }
}

class MockLoginScreen extends StatelessWidget {
  const MockLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Login Screen'),
    );
  }
}
