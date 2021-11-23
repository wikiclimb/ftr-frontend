// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:wikiclimb_flutter_frontend/features/area/presentation/bloc/list/areas_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/area/presentation/widgets/area_list.dart';
import 'package:wikiclimb_flutter_frontend/features/area/presentation/widgets/area_list_item.dart';

import '../../../../fixtures/area/area_nodes.dart';

class MockAreasBloc extends MockBloc<AreasEvent, AreasState>
    implements AreasBloc {}

class FakeAreasState extends Fake implements AreasState {}

class FakeAreasEvent extends Fake implements AreasEvent {}

extension on WidgetTester {
  Future<void> pumpAreasList(AreasBloc bloc) {
    return pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<AreasBloc>(
            create: (context) => bloc,
            child: AreaList(),
          ),
        ),
      ),
    );
  }
}

void main() {
  late AreasBloc bloc;

  setUpAll(() async {
    registerFallbackValue(FakeAreasState());
    registerFallbackValue(FakeAreasEvent());
  });

  group('initial state', () {
    setUp(() async {
      bloc = MockAreasBloc();
      when(() => bloc.state).thenAnswer(
        (_) => AreasState(
          status: AreasStatus.initial,
          areas: BuiltSet(),
          hasError: false,
          nextPage: 1,
        ),
      );
    });

    testWidgets('widget can be created', (tester) async {
      await tester.pumpAreasList(bloc);
      expect(find.byType(AreaList), findsOneWidget);
      expect(
        find.byType(CircularProgressIndicator),
        findsOneWidget,
        reason: 'should display a loader when status is initial',
      );
    });
  });

  group('loaded', () {
    group('no data', () {
      late AreasBloc bloc;
      setUp(() async {
        bloc = MockAreasBloc();
        when(() => bloc.state).thenAnswer(
          (_) => AreasState(
            status: AreasStatus.loaded,
            areas: BuiltSet(),
            hasError: false,
            nextPage: 1,
          ),
        );
      });

      testWidgets('widget can be created', (tester) async {
        await mockNetworkImagesFor(
          () => tester.pumpAreasList(bloc),
        );
        expect(find.byType(AreaList), findsOneWidget);
        expect(
          find.text('No items'),
          findsOneWidget,
          reason: 'should display no items',
        );
      });
    });

    group('with data', () {
      setUp(() async {
        bloc = MockAreasBloc();
        when(() => bloc.state).thenAnswer(
          (_) => AreasState(
            status: AreasStatus.loaded,
            areas: BuiltSet.of(areaNodes),
            hasError: false,
            nextPage: 1,
          ),
        );
      });

      testWidgets('renders items and last item', (tester) async {
        await mockNetworkImagesFor(
          () => tester.pumpAreasList(bloc),
        );
        final itemFinder = find.byType(AreaListLastItem);
        final listFinder = find.byType(Scrollable).first;
        verifyNever(() => bloc.add(NextPageRequested()));
        await tester.scrollUntilVisible(
          itemFinder,
          500.0,
          scrollable: listFinder,
        );
        expect(find.byType(AreaListLastItem), findsOneWidget);
        verify(() => bloc.add(NextPageRequested())).called(1);
      });

      testWidgets('scrolling to bottom requests more pages', (tester) async {
        await mockNetworkImagesFor(
          () => tester.pumpAreasList(bloc),
        );
        final listFinder = find.byType(Scrollable).first;
        final itemFinder = find.byType(AreaListLastItem);
        verifyNever(() => bloc.add(NextPageRequested()));
        await tester.scrollUntilVisible(
          itemFinder,
          500.0,
          scrollable: listFinder,
        );
        expect(find.byType(AreaListLastItem), findsOneWidget);
        await tester.drag(
          find.byType(AreaListLastItem),
          const Offset(0, -500),
        );
        verify(() => bloc.add(NextPageRequested())).called(1);
      });
    });

    group('data and error', () {
      late AreasBloc bloc;
      setUp(() async {
        bloc = MockAreasBloc();
        when(() => bloc.state).thenAnswer(
          (_) => AreasState(
            status: AreasStatus.loaded,
            areas: BuiltSet.of([
              areaNodes.first,
              areaNodes.last,
            ]),
            hasError: true,
            nextPage: 1,
          ),
        );
      });

      testWidgets('displays error message inside last tile', (tester) async {
        await mockNetworkImagesFor(
          () => tester.pumpAreasList(bloc),
        );
        expect(find.byType(AreaListItem), findsNWidgets(2));
        final itemFinder = find.byType(AreaListLastItem);
        final listFinder = find.byType(Scrollable).first;
        verifyNever(() => bloc.add(NextPageRequested()));
        await tester.scrollUntilVisible(
          itemFinder,
          500.0,
          scrollable: listFinder,
        );
        expect(find.byType(AreaListLastItem), findsOneWidget);
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
      late AreasBloc bloc;
      setUp(() async {
        bloc = MockAreasBloc();
        when(() => bloc.state).thenAnswer(
          (_) => AreasState(
            status: AreasStatus.loaded,
            areas: BuiltSet.of(areaNodes),
            hasError: false,
            nextPage: -1,
          ),
        );
      });

      testWidgets('scrolling to bottom does not request pages', (tester) async {
        await mockNetworkImagesFor(
          () => tester.pumpAreasList(bloc),
        );
        final listFinder = find.byType(Scrollable).first;
        final itemFinder = find.byType(AreaListLastItem);
        verifyNever(() => bloc.add(NextPageRequested()));
        await tester.scrollUntilVisible(
          itemFinder,
          500.0,
          scrollable: listFinder,
        );
        expect(find.byType(AreaListLastItem), findsOneWidget);
        expect(
          find.descendant(
            of: itemFinder,
            matching: find.text('No more items'),
          ),
          findsOneWidget,
        );
        await tester.drag(
          find.byType(AreaListLastItem),
          const Offset(0, -500),
        );
        verifyNever(() => bloc.add(NextPageRequested()));
      });
    });
  });

  group('loading', () {
    setUp(() async {
      bloc = MockAreasBloc();
      when(() => bloc.state).thenAnswer(
        (_) => AreasState(
          status: AreasStatus.loading,
          areas: BuiltSet.of(areaNodes),
          hasError: false,
          nextPage: 1,
        ),
      );
    });

    testWidgets('displays loading indicator inside last tile', (tester) async {
      await mockNetworkImagesFor(
        () => tester.pumpAreasList(bloc),
      );
      final itemFinder = find.byType(AreaListLastItem);
      final listFinder = find.byType(Scrollable).first;
      verifyNever(() => bloc.add(NextPageRequested()));
      await tester.scrollUntilVisible(
        itemFinder,
        500.0,
        scrollable: listFinder,
      );
      expect(find.byType(AreaListLastItem), findsOneWidget);
      verify(() => bloc.add(NextPageRequested())).called(1);
      expect(
        find.descendant(
          of: itemFinder,
          matching: find.byType(CircularProgressIndicator),
        ),
        findsOneWidget,
      );
    });
  });
}
