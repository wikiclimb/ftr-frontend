// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:wikiclimb_flutter_frontend/features/map/presentation/bloc/map_view/map_view_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/map/presentation/screens/map_screen.dart';
import 'package:wikiclimb_flutter_frontend/features/map/presentation/widgets/map_view_wrapper.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/node.dart';

class MockMapViewBloc extends MockBloc<MapViewEvent, MapViewState>
    implements MapViewBloc {}

class FakeMapViewState extends Fake implements MapViewState {}

class FakeMapViewEvent extends Fake implements MapViewEvent {}

extension on WidgetTester {
  Future<void> pumpIt() {
    return mockNetworkImagesFor(
      () => pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: MapScreen(),
          ),
        ),
      ),
    );
  }
}

void main() {
  late final GetIt sl;
  late final MapViewBloc mockMapViewBloc;

  setUpAll(() async {
    registerFallbackValue(FakeMapViewState());
    registerFallbackValue(FakeMapViewEvent());
    sl = GetIt.instance;
    mockMapViewBloc = MockMapViewBloc();
    when(() => mockMapViewBloc.state).thenAnswer(
      (_) => MapViewState(
        status: MapViewStatus.initial,
        nodes: BuiltSet<Node>(),
      ),
    );
    sl.registerFactory<MapViewBloc>(() => mockMapViewBloc);
  });

  test('is routable', () {
    expect(MapScreen.route(), isA<MaterialPageRoute>());
  });

  testWidgets('widget renders', (tester) async {
    await tester.pumpIt();
    expect(find.byType(MapScreen), findsOneWidget);
  });

  testWidgets('widget renders child', (tester) async {
    await tester.pumpIt();
    expect(find.byType(MapViewWrapper), findsOneWidget);
  });
}
