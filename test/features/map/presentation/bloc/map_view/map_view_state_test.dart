import 'package:built_collection/built_collection.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wikiclimb_flutter_frontend/features/map/presentation/bloc/map_view/map_view_bloc.dart';

import '../../../../../fixtures/map/map_nodes.dart';

void main() {
  final tState = MapViewState(
    status: MapViewStatus.initial,
    nodes: BuiltSet(),
  );

  test('equality', () {
    expect(
      tState,
      MapViewState(
        status: MapViewStatus.initial,
        nodes: BuiltSet(),
      ),
    );
  });

  test('copy with', () {
    expect(
      tState.copyWith(
        status: MapViewStatus.failure,
        nodes: BuiltSet(mapNodes),
      ),
      MapViewState(
        status: MapViewStatus.failure,
        nodes: BuiltSet(mapNodes),
      ),
    );

    expect(
      tState.copyWith(
        nodes: BuiltSet(mapNodes),
      ),
      MapViewState(
        status: MapViewStatus.initial,
        nodes: BuiltSet(mapNodes),
      ),
    );
  });

  test('props', () {
    expect(
      tState.props,
      unorderedEquals([BuiltSet(), MapViewStatus.initial]),
    );
  });

  test('get markers', () {
    final tMarkers = MapViewState(
      status: MapViewStatus.loaded,
      nodes: BuiltSet(mapNodes),
    ).markers;
    final tMarker = tMarkers.first;
    expect(tMarkers.length, equals(4));
    expect(tMarker, isA<Marker>());
    expect(tMarker.point.latitude, equals(38.501));
    expect(tMarker.point.longitude, equals(-4.091));
  });
}
