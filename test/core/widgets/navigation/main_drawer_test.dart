import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wikiclimb_flutter_frontend/core/widgets/navigation/main_drawer.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/entities/authentication_data.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/presentation/bloc/authentication_cubit.dart';
import 'package:wikiclimb_flutter_frontend/features/home/presentation/screens/home_screen.dart';
import 'package:wikiclimb_flutter_frontend/features/login/presentation/screens/login_screen.dart';
import 'package:wikiclimb_flutter_frontend/features/login/presentation/widgets/login_drawer_tile.dart';

class MockAuthenticationCubit extends MockCubit<AuthenticationState>
    implements AuthenticationCubit {}

class FakeAuthenticationState extends Fake implements AuthenticationState {}

void main() {
  late final MockAuthenticationCubit authCubit;
  const tAuthData = AuthenticationData(
    token: 'token',
    id: 123,
  );

  setUpAll(() async {
    registerFallbackValue(FakeAuthenticationState());
    authCubit = MockAuthenticationCubit();
  });

  testWidgets(
    'displays login tile when not in login screen',
    (WidgetTester tester) async {
      whenListen(
        authCubit,
        Stream.fromIterable([
          const AuthenticationSuccess(tAuthData),
        ]),
        initialState: AuthenticationInitial(),
      );
      await pumpDrawer(
        tester,
        authCubit,
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
        authCubit,
        Stream.fromIterable([
          const AuthenticationSuccess(tAuthData),
        ]),
        initialState: AuthenticationInitial(),
      );
      await pumpDrawer(
        tester,
        authCubit,
        LoginScreen.id,
      );
      expect(find.byType(LoginDrawerTile), findsNothing);
    },
  );
}

Future<void> pumpDrawer(
  WidgetTester tester,
  AuthenticationCubit authCubit,
  String currentRoute,
) async {
  await tester.pumpWidget(
    MaterialApp(
      home: BlocProvider<AuthenticationCubit>(
        create: (BuildContext context) => authCubit,
        child: Scaffold(
          body: MainDrawer(
            currentRoute: currentRoute,
          ),
        ),
      ),
    ),
  );
}
