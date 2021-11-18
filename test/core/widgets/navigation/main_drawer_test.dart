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
      await pumpDrawer(
        tester,
        authBloc,
        HomeScreen.id,
      );
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
      await pumpDrawer(
        tester,
        authBloc,
        LoginScreen.id,
      );
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
      await pumpDrawer(
        tester,
        authBloc,
        LoginScreen.id,
      );
      expect(find.text('Areas'), findsOneWidget);
      await tester.tap(find.text('Areas'));
    },
  );
}

Future<void> pumpDrawer(
  WidgetTester tester,
  AuthenticationBloc authCubit,
  String currentRoute,
) async {
  await tester.pumpWidget(
    MaterialApp(
      home: BlocProvider<AuthenticationBloc>(
        create: (BuildContext context) => authCubit,
        child: Scaffold(
          body: MainDrawer(
            currentRoute: currentRoute,
          ),
        ),
      ),
      routes: {
        AreaListScreen.id: (context) => const MockAreaListScreen(),
      },
    ),
  );
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
