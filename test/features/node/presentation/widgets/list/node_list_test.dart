// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/bloc/node_list/node_list_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/widgets/list/node_list.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/widgets/list/node_list_item.dart';

import '../../../../../fixtures/node/nodes.dart';

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
            child: NodeList(),
          ),
        ),
      ),
    );
  }
}

void main() {
  late NodeListBloc bloc;

  setUpAll(() async {
    registerFallbackValue(FakeNodeListState());
    registerFallbackValue(FakeNodeListEvent());
  });

  group('initial state', () {
    setUp(() async {
      bloc = MockNodeListBloc();
      when(() => bloc.state).thenAnswer(
        (_) => NodeListState(
          status: NodeListStatus.initial,
          nodes: BuiltSet(),
          hasError: false,
          nextPage: 1,
        ),
      );
    });

    testWidgets('widget can be created', (tester) async {
      await tester.pumpIt(bloc);
      expect(find.byType(NodeList), findsOneWidget);
      expect(
        find.byType(CircularProgressIndicator),
        findsOneWidget,
        reason: 'should display a loader when status is initial',
      );
    });
  });

  group('loaded', () {
    group('no data', () {
      late NodeListBloc bloc;
      setUp(() async {
        bloc = MockNodeListBloc();
        when(() => bloc.state).thenAnswer(
          (_) => NodeListState(
            status: NodeListStatus.loaded,
            nodes: BuiltSet(),
            hasError: false,
            nextPage: 1,
          ),
        );
      });

      testWidgets('widget can be created', (tester) async {
        await mockNetworkImagesFor(
          () => tester.pumpIt(bloc),
        );
        expect(find.byType(NodeList), findsOneWidget);
        expect(
          find.text('No items'),
          findsOneWidget,
          reason: 'should display no items',
        );
      });
    });

    group('with data', () {
      setUp(() async {
        bloc = MockNodeListBloc();
        when(() => bloc.state).thenAnswer(
          (_) => NodeListState(
            status: NodeListStatus.loaded,
            nodes: BuiltSet.of(nodes),
            hasError: false,
            nextPage: 1,
          ),
        );
      });

      testWidgets('renders items and last item', (tester) async {
        await mockNetworkImagesFor(
          () => tester.pumpIt(bloc),
        );
        final itemFinder = find.byType(NodeListLastItem);
        final listFinder = find.byType(Scrollable).first;
        verifyNever(() => bloc.add(NextPageRequested()));
        await tester.scrollUntilVisible(
          itemFinder,
          500.0,
          scrollable: listFinder,
        );
        expect(find.byType(NodeListLastItem), findsOneWidget);
        verify(() => bloc.add(NextPageRequested())).called(1);
      });

      testWidgets('scrolling to bottom requests more pages', (tester) async {
        await mockNetworkImagesFor(
          () => tester.pumpIt(bloc),
        );
        final listFinder = find.byType(Scrollable).first;
        final itemFinder = find.byType(NodeListLastItem);
        verifyNever(() => bloc.add(NextPageRequested()));
        await tester.scrollUntilVisible(
          itemFinder,
          500.0,
          scrollable: listFinder,
        );
        expect(find.byType(NodeListLastItem), findsOneWidget);
        await tester.drag(
          find.byType(NodeListLastItem),
          const Offset(0, -500),
        );
        verify(() => bloc.add(NextPageRequested())).called(1);
      });
    });

    group('data and error', () {
      late NodeListBloc bloc;
      setUp(() async {
        bloc = MockNodeListBloc();
        when(() => bloc.state).thenAnswer(
          (_) => NodeListState(
            status: NodeListStatus.loaded,
            nodes: BuiltSet.of([
              nodes.first,
              nodes.last,
            ]),
            hasError: true,
            nextPage: 1,
          ),
        );
      });

      testWidgets('displays error message inside last tile', (tester) async {
        await mockNetworkImagesFor(
          () => tester.pumpIt(bloc),
        );
        expect(find.byType(NodeListItem), findsNWidgets(2));
        final itemFinder = find.byType(NodeListLastItem);
        final listFinder = find.byType(Scrollable).first;
        verifyNever(() => bloc.add(NextPageRequested()));
        await tester.scrollUntilVisible(
          itemFinder,
          500.0,
          scrollable: listFinder,
        );
        expect(find.byType(NodeListLastItem), findsOneWidget);
        expect(
          find.descendant(
            of: itemFinder,
            matching: find.text('Has an error'),
          ),
          findsOneWidget,
        );
      });
    });

    group('data is last page', () {
      late NodeListBloc bloc;
      setUp(() async {
        bloc = MockNodeListBloc();
        when(() => bloc.state).thenAnswer(
          (_) => NodeListState(
            status: NodeListStatus.loaded,
            nodes: BuiltSet.of(nodes),
            hasError: false,
            nextPage: -1,
          ),
        );
      });

      testWidgets('scrolling to bottom does not request pages', (tester) async {
        await mockNetworkImagesFor(
          () => tester.pumpIt(bloc),
        );
        final listFinder = find.byType(Scrollable).first;
        final itemFinder = find.byType(NodeListLastItem);
        verifyNever(() => bloc.add(NextPageRequested()));
        await tester.scrollUntilVisible(
          itemFinder,
          500.0,
          scrollable: listFinder,
        );
        expect(find.byType(NodeListLastItem), findsOneWidget);
        expect(
          find.descendant(
            of: itemFinder,
            matching: find.text('No more items'),
          ),
          findsOneWidget,
        );
        await tester.drag(
          find.byType(NodeListLastItem),
          const Offset(0, -500),
        );
        verifyNever(() => bloc.add(NextPageRequested()));
      });
    });
  });

  group('loading', () {
    setUp(() async {
      bloc = MockNodeListBloc();
      when(() => bloc.state).thenAnswer(
        (_) => NodeListState(
          status: NodeListStatus.loading,
          nodes: BuiltSet.of(nodes),
          hasError: false,
          nextPage: 1,
        ),
      );
    });

    testWidgets('displays loading indicator', (tester) async {
      await mockNetworkImagesFor(
        () => tester.pumpIt(bloc),
      );
      expect(
        find.byType(CircularProgressIndicator),
        findsOneWidget,
      );
    });
  });
}
