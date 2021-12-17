// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/bloc/node_list/node_list_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/widgets/search/node_search_bar.dart';

class MockNodeListBloc extends MockBloc<NodeListEvent, NodeListState>
    implements NodeListBloc {}

class FakeNodeListState extends Fake implements NodeListState {}

class FakeNodeListEvent extends Fake implements NodeListEvent {}

extension on WidgetTester {
  Future<void> pumpIt(NodeListBloc bloc) {
    return pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<NodeListBloc>(
            create: (context) => bloc,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(),
                NodeSearchBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  late NodeListBloc bloc;
  final tState = NodeListState(
    status: NodeListStatus.initial,
    nodes: BuiltSet(),
    hasError: false,
    nextPage: 1,
  );

  setUpAll(() async {
    registerFallbackValue(FakeNodeListState());
    registerFallbackValue(FakeNodeListEvent());
    bloc = MockNodeListBloc();
  });

  testWidgets('widget renders', (tester) async {
    when(() => bloc.state).thenAnswer((_) => tState);
    await tester.pumpIt(bloc);
    expect(find.byType(NodeSearchBar), findsOneWidget);
  });

  group('input', () {
    testWidgets('adds event to bloc', (tester) async {
      const searchTerm = 'hocus';
      final tLoaded = tState.copyWith(status: NodeListStatus.loaded);
      final tEvent = SearchQueryUpdated(query: searchTerm);
      when(() => bloc.state).thenAnswer((_) => tLoaded);
      await tester.pumpIt(bloc);
      final finder = find.text('Search...');
      expect(finder, findsOneWidget);
      await tester.tap(finder);
      await tester.pumpAndSettle();
      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);
      await tester.enterText(textField, searchTerm);
      await tester.pumpAndSettle();
      verify(() => bloc.add(tEvent)).called(1);
    });
  });
}
