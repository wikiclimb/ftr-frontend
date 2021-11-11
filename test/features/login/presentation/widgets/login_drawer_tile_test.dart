import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/entities/authentication_data.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/login/presentation/widgets/login_drawer_tile.dart';

class MockAuthenticationBloc extends MockCubit<AuthenticationState>
    implements AuthenticationBloc {}

class FakeAuthenticationState extends Fake implements AuthenticationState {}

void main() {
  late final MockAuthenticationBloc authCubit;
  const tAuthData = AuthenticationData(
    token: 'token',
    id: 123,
  );

  setUpAll(() async {
    registerFallbackValue(FakeAuthenticationState());
    authCubit = MockAuthenticationBloc();
  });

  testWidgets(
    'displays login tile when authentication data is not present',
    (WidgetTester tester) async {
      whenListen(
        authCubit,
        Stream.fromIterable([
          const AuthenticationAuthenticated(tAuthData),
        ]),
        initialState: AuthenticationInitial(),
      );
      await pumpLoginDrawer(tester, authCubit);
      expect(find.byType(LoginTile), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
    },
  );

  testWidgets(
    'displays logout tile when authentication data is present',
    (WidgetTester tester) async {
      whenListen(
        authCubit,
        Stream.fromIterable([
          const AuthenticationAuthenticated(tAuthData),
        ]),
        initialState: const AuthenticationAuthenticated(tAuthData),
      );
      await pumpLoginDrawer(tester, authCubit);
      expect(find.byType(LogoutTile), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);
    },
  );

  testWidgets(
    'displays loading auth tile when authentication data is loading',
    (WidgetTester tester) async {
      whenListen(
        authCubit,
        Stream.fromIterable([
          AuthenticationInitial(),
        ]),
        initialState: AuthenticationInitial(),
      );
      await pumpLoginDrawer(tester, authCubit);
      expect(find.byType(LoadingAuthenticationDataTile), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );
}

Future<void> pumpLoginDrawer(
  WidgetTester tester,
  AuthenticationBloc authCubit,
) async {
  await tester.pumpWidget(
    MaterialApp(
      home: BlocProvider<AuthenticationBloc>(
        create: (BuildContext context) => authCubit,
        child: const Scaffold(
          body: LoginDrawerTile(),
        ),
      ),
    ),
  );
}
