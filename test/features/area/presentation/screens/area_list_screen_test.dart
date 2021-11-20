// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import 'package:wikiclimb_flutter_frontend/features/area/presentation/bloc/list/areas_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/area/presentation/screens/add_area_screen.dart';
import 'package:wikiclimb_flutter_frontend/features/area/presentation/screens/area_list_screen.dart';
import 'package:wikiclimb_flutter_frontend/features/area/presentation/widgets/area_list.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/entities/authentication_data.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/presentation/bloc/authentication_bloc.dart';

class MockAreasBloc extends MockBloc<AreasEvent, AreasState>
    implements AreasBloc {}

class MockAuthenticationBloc
    extends MockBloc<AuthenticationEvent, AuthenticationState>
    implements AuthenticationBloc {}

class FakeAreasState extends Fake implements AreasState {}

class FakeAreasEvent extends Fake implements AreasEvent {}

extension on WidgetTester {
  Future<void> pumpAreasListScreen(
    AreasBloc bloc,
    AuthenticationBloc authBloc,
  ) {
    return pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MultiBlocProvider(
            providers: [
              BlocProvider<AreasBloc>(
                create: (context) => bloc,
              ),
              BlocProvider<AuthenticationBloc>(
                create: (context) => authBloc,
              ),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: AreaListScreen(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  late final GetIt sl;
  late final AreasBloc bloc;
  late final AuthenticationBloc authBloc;

  setUpAll(() async {
    registerFallbackValue(FakeAreasState());
    registerFallbackValue(FakeAreasEvent());

    sl = GetIt.instance;
    bloc = MockAreasBloc();
    sl.registerFactory<AreasBloc>(() => bloc);
    authBloc = MockAuthenticationBloc();
    sl.registerFactory<AuthenticationBloc>(() => authBloc);
  });

  group('without area data', () {
    setUp(() {
      when(() => bloc.state).thenAnswer(
        (_) => AreasState(
          status: AreasStatus.initial,
          areas: BuiltSet(),
          hasError: false,
          nextPage: 1,
        ),
      );
    });

    testWidgets('renders an areas list', (tester) async {
      when(() => authBloc.state).thenAnswer(
        (_) => AuthenticationUnauthenticated(),
      );
      await tester.pumpAreasListScreen(bloc, authBloc);
      expect(find.byType(AreaList), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsNothing);
      verify(() => bloc.state).called(greaterThan(0));
    });

    group('authenticated', () {
      setUp(() {
        final tAuthData = AuthenticationData(
          token: 'token',
          id: 1,
          username: 'test-username',
        );
        when(() => authBloc.state).thenAnswer(
          (_) => AuthenticationAuthenticated(tAuthData),
        );
      });

      testWidgets('shows add area fab when authenticated', (tester) async {
        await tester.pumpAreasListScreen(bloc, authBloc);
        expect(find.byType(AreaList), findsOneWidget);
        expect(find.byType(FloatingActionButton), findsOneWidget);
        verify(() => bloc.state).called(greaterThan(0));
        verify(() => authBloc.state).called(greaterThan(0));
      });

      testWidgets('tapping fab navigates to add area screen', (tester) async {
        await tester.pumpAreasListScreen(bloc, authBloc);
        expect(find.byType(AreaList), findsOneWidget);
        expect(find.byType(FloatingActionButton), findsOneWidget);
        verify(() => bloc.state).called(greaterThan(0));
        verify(() => authBloc.state).called(greaterThan(0));
        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();
        expect(find.byType(AddAreaScreen), findsOneWidget);
      });
    });
  });
}
