import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/entities/authentication_data.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/presentation/bloc/authentication_cubit.dart';
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
    'displays login tile when authentication data is not present',
    (WidgetTester tester) async {
      whenListen(
        authCubit,
        Stream.fromIterable([
          const AuthenticationSuccess(tAuthData),
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
          const AuthenticationSuccess(tAuthData),
        ]),
        initialState: const AuthenticationSuccess(tAuthData),
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
          AuthenticationLoading(),
        ]),
        initialState: AuthenticationLoading(),
      );
      await pumpLoginDrawer(tester, authCubit);
      expect(find.byType(LoadingAuthenticationDataTile), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );
}

Future<void> pumpLoginDrawer(
  WidgetTester tester,
  AuthenticationCubit authCubit,
) async {
  await tester.pumpWidget(
    MaterialApp(
      home: BlocProvider<AuthenticationCubit>(
        create: (BuildContext context) => authCubit,
        child: const Scaffold(
          body: LoginDrawerTile(),
        ),
      ),
    ),
  );
}
