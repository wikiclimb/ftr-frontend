import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:wikiclimb_flutter_frontend/features/map/domain/entities/node_marker.dart';

import '../../../../fixtures/node/nodes.dart';

void main() {
  test('can create', () {
    final n = nodes.elementAt(3);
    final nodeMarker = NodeMarker(
      key: Key('mapView_nodeMarker_node_${n.id}'),
      anchorPos: AnchorPos.align(AnchorAlign.center),
      height: 30,
      width: 30,
      point: LatLng(n.lat!, n.lng!),
      builder: (ctx) => const Icon(Icons.pin_drop),
      node: n,
    );
    expect(nodeMarker, isA<Marker>());
  });
}
