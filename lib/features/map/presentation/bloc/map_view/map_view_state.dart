part of 'map_view_bloc.dart';

enum MapViewStatus { initial, loading, loaded, failure }

class MapViewState extends Equatable {
  const MapViewState({
    required this.status,
    required this.nodes,
  });

  final BuiltSet<Node> nodes;
  final MapViewStatus status;

  @override
  List<Object> get props => [status, nodes];

  /// Get a list of [Marker] currently held by this state.
  List<NodeMarker> get markers => nodes
      .where((n) => n.lat != null && n.lng != null)
      .map(
        (n) => NodeMarker(
          key: material.Key('mapView_nodeMarker_node_${n.id}'),
          anchorPos: AnchorPos.align(AnchorAlign.center),
          height: 30,
          width: 30,
          point: LatLng(n.lat!, n.lng!),
          builder: (ctx) => const material.Icon(material.Icons.pin_drop),
          node: n,
        ),
      )
      .toList();

  MapViewState copyWith({
    MapViewStatus? status,
    BuiltSet<Node>? nodes,
  }) =>
      MapViewState(
        status: status ?? this.status,
        nodes: nodes ?? this.nodes,
      );
}
