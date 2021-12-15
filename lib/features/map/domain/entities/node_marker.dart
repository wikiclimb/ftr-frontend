import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../node/domain/entities/node.dart';

/// Override [Marker] to be able to pass a [Node] instance to map methods.
///
/// This class simply wraps [Marker] adding a property that has a [Node]
/// instance. [Marker] consumers can cast to [NodeMarker] to be able to access
/// [Node] data.
///
/// ```
/// final nodeMarker = marker as NodeMarker;
/// final node = nodeMarker.node;
/// ````
///
/// [Node] data can be used to display popups or to know which node the user
/// wants to interact with.
class NodeMarker extends Marker {
  NodeMarker({
    AnchorPos? anchorPos,
    required WidgetBuilder builder,
    double? height,
    Key? key,
    required this.node,
    required LatLng point,
    double? width,
  }) : super(
          anchorPos: anchorPos,
          builder: builder,
          height: height ?? 30,
          key: key,
          point: point,
          width: width ?? 30,
        );

  final Node node;
}
