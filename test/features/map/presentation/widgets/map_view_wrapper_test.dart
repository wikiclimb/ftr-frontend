// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:wikiclimb_flutter_frontend/features/map/presentation/bloc/map_view/map_view_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/map/presentation/widgets/map_view.dart';
import 'package:wikiclimb_flutter_frontend/features/map/presentation/widgets/map_view_wrapper.dart';

class MockMapViewBloc extends MockBloc<MapViewEvent, MapViewState>
    implements MapViewBloc {}

class MockMapViewState extends Mock implements MapViewState {}

class FakeMapViewState extends Fake implements MapViewState {}

class FakeMapViewEvent extends Fake implements MapViewEvent {}

extension on WidgetTester {
  Future<void> pumpIt(MapViewBloc mockMapViewBloc) {
    return pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider<MapViewBloc>(
          create: (context) => mockMapViewBloc,
          child: MapViewWrapper(),
        ),
      ),
    );
  }
}

void main() {
  late final MapViewBloc mockMapViewBloc;
  late final MapViewState mockMapViewState;

  setUpAll(() async {
    registerFallbackValue(FakeMapViewState());
    registerFallbackValue(FakeMapViewEvent());
    mockMapViewState = MockMapViewState();
    when(() => mockMapViewState.markers).thenReturn([]);
    mockMapViewBloc = MockMapViewBloc();
    when(() => mockMapViewBloc.state).thenAnswer((_) => mockMapViewState);
  });

  testWidgets('widget renders', (tester) async {
    await mockNetworkImagesFor(() => tester.pumpIt(mockMapViewBloc));
    await tester.pumpAndSettle();
    expect(find.byType(MapViewWrapper), findsOneWidget);
  });

  testWidgets('widget renders child', (tester) async {
    await mockNetworkImagesFor(() => tester.pumpIt(mockMapViewBloc));
    await tester.pumpAndSettle();
    expect(find.byType(MapView), findsOneWidget);
  });
}
