// ignore_for_file: prefer_const_constructors

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/entities/authentication_data.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/home/presentation/screens/home_screen.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/bloc/node_list/node_list_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/widgets/list/node_list.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/widgets/list/node_list_item.dart';

import '../../../../fixtures/node/nodes.dart';

class MockAuthenticationBloc
    extends MockBloc<AuthenticationEvent, AuthenticationState>
    implements AuthenticationBloc {}

class MockNodeListBloc extends MockBloc<NodeListEvent, NodeListState>
    implements NodeListBloc {}

class FakeAuthenticationEvent extends Fake implements AuthenticationEvent {}

class FakeAuthenticationState extends Fake implements AuthenticationState {}

class FakeNodeListState extends Fake implements NodeListState {}

class FakeNodeListEvent extends Fake implements NodeListEvent {}

extension on WidgetTester {
  Future<void> pumpIt(
    NodeListBloc mockNodeListBloc,
    AuthenticationBloc mockAuthBloc,
  ) {
    return pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MultiBlocProvider(
            providers: [
              BlocProvider<NodeListBloc>(
                create: (context) => mockNodeListBloc,
              ),
              BlocProvider<AuthenticationBloc>(
                create: (context) => mockAuthBloc,
              ),
            ],
            child: MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: Scaffold(
                body: HomeScreen(),
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
  late final NodeListBloc mockNodeListBloc;
  late final AuthenticationBloc mockAuthBloc;

  setUpAll(() {
    registerFallbackValue(FakeNodeListState());
    registerFallbackValue(FakeNodeListEvent());
    registerFallbackValue(FakeAuthenticationEvent());
    registerFallbackValue(FakeAuthenticationState());
    mockNodeListBloc = MockNodeListBloc();
    when(() => mockNodeListBloc.state).thenReturn(NodeListState(
      status: NodeListStatus.initial,
      nodes: BuiltSet(nodes),
      hasError: false,
      nextPage: 1,
    ));
    mockAuthBloc = MockAuthenticationBloc();
    sl = GetIt.instance;
    sl.registerFactory<NodeListBloc>(() => mockNodeListBloc);
  });

  testWidgets('HomeScreen displays for guest', (WidgetTester tester) async {
    when(() => mockAuthBloc.state)
        .thenAnswer((_) => AuthenticationUnauthenticated());
    await tester.pumpIt(mockNodeListBloc, mockAuthBloc);
    expect(find.text('Hello guest'), findsOneWidget);
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('HomeScreen displays for authenticated',
      (WidgetTester tester) async {
    const tAuthData = AuthenticationData(
      token: 'token',
      id: 123,
      username: 'test-username',
    );
    when(() => mockAuthBloc.state).thenAnswer(
      (_) => const AuthenticationAuthenticated(tAuthData),
    );
    await tester.pumpIt(mockNodeListBloc, mockAuthBloc);
    expect(find.text('Hello test-username'), findsOneWidget);
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(NodeListItem), findsWidgets);
    final itemFinder = find.byType(NodeListLastItem);
    final listFinder = find.byType(Scrollable).first;
    await tester.scrollUntilVisible(
      itemFinder,
      500.0,
      scrollable: listFinder,
    );
    expect(itemFinder, findsWidgets);
  });
}
