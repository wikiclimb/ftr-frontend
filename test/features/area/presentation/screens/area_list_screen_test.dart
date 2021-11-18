// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import 'package:wikiclimb_flutter_frontend/features/area/presentation/bloc/list/areas_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/area/presentation/screens/area_list_screen.dart';
import 'package:wikiclimb_flutter_frontend/features/area/presentation/widgets/area_list.dart';

class MockAreasBloc extends MockBloc<AreasEvent, AreasState>
    implements AreasBloc {}

class FakeAreasState extends Fake implements AreasState {}

class FakeAreasEvent extends Fake implements AreasEvent {}

void main() {
  late final GetIt sl;
  late final AreasBloc bloc;

  setUpAll(() async {
    registerFallbackValue(FakeAreasState());
    registerFallbackValue(FakeAreasEvent());

    sl = GetIt.instance;
    bloc = MockAreasBloc();
    sl.registerFactory<AreasBloc>(() => bloc);
  });

  testWidgets('renders an areas list', (tester) async {
    when(() => bloc.state).thenAnswer(
      (_) => AreasState(
        status: AreasStatus.initial,
        areas: BuiltSet(),
        hasError: false,
        nextPage: 1,
      ),
    );
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: AreaListScreen()),
      ),
    );
    expect(find.byType(AreaList), findsOneWidget);
    // await tester.pumpAndSettle();
    verify(() => bloc.state).called(greaterThan(0));
  });
}
