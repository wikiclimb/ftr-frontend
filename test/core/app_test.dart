import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:wikiclimb_flutter_frontend/core/app.dart';
import 'package:wikiclimb_flutter_frontend/core/widgets/form/decorated_icon_input.dart';
import 'package:mocktail/mocktail.dart';

import 'package:bloc_test/bloc_test.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/presentation/bloc/login_bloc.dart';

class MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginBloc {}

class FakeLoginState extends Fake implements LoginState {}

class FakeLoginEvent extends Fake implements LoginEvent {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeLoginState());
    registerFallbackValue(FakeLoginEvent());
  });
  testWidgets('Title displays', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    expect(find.text('WikiClimb'), findsOneWidget);
  });

  // routes on App() are not covered by tests right now
  group('test navigation', () {
    late final GetIt sl;
    late final LoginBloc loginBloc;

    setUp(() async {
      sl = GetIt.instance;
      loginBloc = MockLoginBloc();
      sl.registerFactory<LoginBloc>(() => loginBloc);
    });

    testWidgets('LoginScreen displays', (WidgetTester tester) async {
      whenListen(
        loginBloc,
        Stream.fromIterable([LoginInitial()]),
        initialState: LoginInitial(),
      );
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
