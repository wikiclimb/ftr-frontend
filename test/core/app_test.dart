import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:wikiclimb_flutter_frontend/core/app.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/home/presentation/screens/home_screen.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/bloc/node_list/node_list_bloc.dart';

import '../fixtures/node/nodes.dart';

class MockAuthenticationBloc
    extends MockBloc<AuthenticationEvent, AuthenticationState>
    implements AuthenticationBloc {}

class FakeAuthenticationEvent extends Fake implements AuthenticationEvent {}

class FakeAuthenticationState extends Fake implements AuthenticationState {}

class MockNodeListBloc extends MockBloc<NodeListEvent, NodeListState>
    implements NodeListBloc {}

class FakeNodeListState extends Fake implements NodeListState {}

class FakeNodeListEvent extends Fake implements NodeListEvent {}

void main() {
  late final AuthenticationBloc authBloc;
  late final GetIt sl;
  late final NodeListBloc mockNodeListBloc;

  setUpAll(() {
    registerFallbackValue(FakeAuthenticationEvent());
    registerFallbackValue(FakeAuthenticationState());
    mockNodeListBloc = MockNodeListBloc();
    when(() => mockNodeListBloc.state).thenReturn(NodeListState(
      status: NodeListStatus.initial,
      nodes: BuiltSet(nodes),
      hasError: false,
      nextPage: 1,
    ));
    sl = GetIt.instance;
    sl.registerFactory<NodeListBloc>(() => mockNodeListBloc);
  });

  setUp(() {
    authBloc = MockAuthenticationBloc();
  });

  testWidgets('App displays', (WidgetTester tester) async {
    when(() => authBloc.state)
        .thenAnswer((_) => AuthenticationUnauthenticated());
    await tester.pumpWidget(
      BlocProvider(
        create: (BuildContext context) => authBloc,
        child: const App(),
      ),
    );
    expect(find.text('Hello guest'), findsOneWidget);
    expect(find.byType(App), findsOneWidget);
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
