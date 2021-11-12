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
  late final MockAuthenticationBloc authBloc;
  const tAuthData = AuthenticationData(
    token: 'token',
    id: 123,
  );

  setUpAll(() async {
    registerFallbackValue(FakeAuthenticationState());
    authBloc = MockAuthenticationBloc();
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
