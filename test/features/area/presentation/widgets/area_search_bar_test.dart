// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wikiclimb_flutter_frontend/features/area/presentation/bloc/list/areas_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/area/presentation/widgets/area_search_bar.dart';

class MockAreasBloc extends MockBloc<AreasEvent, AreasState>
    implements AreasBloc {}

class FakeAreasState extends Fake implements AreasState {}

class FakeAreasEvent extends Fake implements AreasEvent {}

extension on WidgetTester {
  Future<void> pumpIt(AreasBloc bloc) {
    return pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<AreasBloc>(
            create: (context) => bloc,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(),
                AreaSearchBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  late AreasBloc bloc;
  final tState = AreasState(
    status: AreasStatus.initial,
    areas: BuiltSet(),
    hasError: false,
    nextPage: 1,
  );

  setUpAll(() async {
    registerFallbackValue(FakeAreasState());
    registerFallbackValue(FakeAreasEvent());
    bloc = MockAreasBloc();
  });

  testWidgets('widget renders', (tester) async {
    when(() => bloc.state).thenAnswer((_) => tState);
    await tester.pumpIt(bloc);
    expect(find.byType(AreaSearchBar), findsOneWidget);
  });

  group('input', () {
    testWidgets('adds event to bloc', (tester) async {
      const searchTerm = 'hocus';
      final tLoaded = tState.copyWith(status: AreasStatus.loaded);
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
