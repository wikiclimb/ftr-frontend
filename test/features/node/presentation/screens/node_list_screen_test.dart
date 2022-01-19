// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/entities/authentication_data.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/node.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/bloc/node_edit/node_edit_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/bloc/node_list/node_list_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/screens/add_node_screen.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/screens/node_list_screen.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/widgets/list/node_list.dart';

import '../../../../fixtures/node/nodes.dart';

class MockNodeListBloc extends MockBloc<NodeListEvent, NodeListState>
    implements NodeListBloc {}

class MockAuthenticationBloc
    extends MockBloc<AuthenticationEvent, AuthenticationState>
    implements AuthenticationBloc {}

class MockNodeEditBloc extends MockBloc<NodeEditEvent, NodeEditState>
    implements NodeEditBloc {}

class FakeNodeListState extends Fake implements NodeListState {}

class FakeNodeListEvent extends Fake implements NodeListEvent {}

extension on WidgetTester {
  Future<void> pumpIt(NodeListBloc bloc, AuthenticationBloc authBloc,
      {int? type}) {
    return pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: MultiBlocProvider(
            providers: [
              BlocProvider<NodeListBloc>(
                create: (context) => bloc,
              ),
              BlocProvider<AuthenticationBloc>(
                create: (context) => authBloc,
              ),
            ],
            child: NodeListScreen(type: type),
          ),
        ),
      ),
    );
  }
}

void main() {
  late final GetIt sl;
  late final NodeListBloc bloc;
  late final AuthenticationBloc authBloc;
  late final MockNodeEditBloc mockNodeEditBloc;

  setUpAll(() async {
    registerFallbackValue(FakeNodeListState());
    registerFallbackValue(FakeNodeListEvent());

    sl = GetIt.instance;
    bloc = MockNodeListBloc();
    sl.registerFactory<NodeListBloc>(() => bloc);
    authBloc = MockAuthenticationBloc();
    sl.registerFactory<AuthenticationBloc>(() => authBloc);
    mockNodeEditBloc = MockNodeEditBloc();
    sl.registerFactoryParam<NodeEditBloc, Node, void>(
        (node, _) => mockNodeEditBloc);
  });

  group('without node data', () {
    setUp(() {
      when(() => bloc.state).thenAnswer(
        (_) => NodeListState(
          status: NodeListStatus.initial,
          nodes: BuiltSet(),
          hasError: false,
          nextPage: 1,
        ),
      );
    });

    testWidgets('renders an nodes list', (tester) async {
      when(() => authBloc.state).thenAnswer(
        (_) => AuthenticationUnauthenticated(),
      );
      await tester.pumpIt(bloc, authBloc);
      expect(find.byType(NodeList), findsOneWidget);
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
        when(() => mockNodeEditBloc.state).thenAnswer(
          (_) => NodeEditState(node: nodes.first),
        );
      });

      testWidgets('shows add node fab when authenticated', (tester) async {
        await tester.pumpIt(bloc, authBloc, type: 1);
        expect(find.byType(NodeList), findsOneWidget);
        expect(find.byType(FloatingActionButton), findsOneWidget);
        verify(() => bloc.state).called(greaterThan(0));
        verify(() => authBloc.state).called(greaterThan(0));
      });

      testWidgets('tapping fab navigates to add node screen', (tester) async {
        await tester.pumpIt(bloc, authBloc, type: 2);
        expect(find.byType(NodeList), findsOneWidget);
        expect(find.byType(FloatingActionButton), findsOneWidget);
        verify(() => bloc.state).called(greaterThan(0));
        verify(() => authBloc.state).called(greaterThan(0));
        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();
        expect(find.byType(AddNodeScreen), findsOneWidget);
      });
    });
  });
}
