import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:wikiclimb_flutter_frontend/core/app.dart';
import 'package:wikiclimb_flutter_frontend/core/widgets/form/decorated_icon_input.dart';
import 'package:mocktail/mocktail.dart';

import 'package:bloc_test/bloc_test.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/entities/authentication_data.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/presentation/bloc/authentication_cubit.dart';
import 'package:wikiclimb_flutter_frontend/features/login/presentation/bloc/login_bloc.dart';

// LoginBloc mocks
class MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginBloc {}

class FakeLoginState extends Fake implements LoginState {}

class FakeLoginEvent extends Fake implements LoginEvent {}

// AuthenticationCubit Mocks
class MockAuthCubit extends MockCubit<AuthenticationState>
    implements AuthenticationCubit {}

class FakeAuthenticationState extends Fake implements AuthenticationState {}

void main() {
  late final GetIt sl;
  late final LoginBloc loginBloc;
  late final AuthenticationCubit authCubit;

  setUpAll(() {
    registerFallbackValue(FakeLoginState());
    registerFallbackValue(FakeLoginEvent());
    registerFallbackValue(FakeAuthenticationState());
    sl = GetIt.instance;
    loginBloc = MockLoginBloc();
    authCubit = MockAuthCubit();
    sl.registerFactory<LoginBloc>(() => loginBloc);
    sl.registerFactory<AuthenticationCubit>(() => authCubit);
  });
  testWidgets('Title displays', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    expect(find.text('WikiClimb'), findsOneWidget);
  });

  // routes on App() are not covered by tests right now
  group('test navigation', () {
    const tAuthData = AuthenticationData(
      token: 'test-token',
      id: 123,
    );
    setUp(() async {
      whenListen(
        loginBloc,
        Stream.fromIterable([LoginInitial()]),
        initialState: LoginInitial(),
      );
      whenListen(
        authCubit,
        Stream.fromIterable([
          AuthenticationInitial(),
          AuthenticationLoading(),
          const AuthenticationSuccess(tAuthData),
        ]),
      );
    });

    testWidgets('LoginScreen displays', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.byIcon(Icons.menu), findsOneWidget);
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      expect(find.text('Login'), findsOneWidget);
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();
      expect(find.byType(DecoratedIconInput), findsNWidgets(2));
    });
  });
}
