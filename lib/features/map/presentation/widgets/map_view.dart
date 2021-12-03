import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';

import '../bloc/map_view/map_view_bloc.dart';

class MapView extends StatelessWidget {
  const MapView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        // TODO fetch position from last time used. Otherwise center on actual.
        center: LatLng(38.5, -4.09),
        zoom: 5.0,
        plugins: [
          MarkerClusterPlugin(),
        ],
        onPositionChanged: (position, tru) {
          context
              .read<MapViewBloc>()
              .add(MapPositionChanged(position: position));
        },
      ),
      layers: [
        TileLayerOptions(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: ['a', 'b', 'c'],
          attributionBuilder: (_) {
            return const Text('© OpenStreetMap contributors');
          },
        ),
        MarkerClusterLayerOptions(
          maxClusterRadius: 120,
          size: const Size(40, 40),
          fitBoundsOptions: const FitBoundsOptions(
            padding: EdgeInsets.all(50),
          ),
          markers: context.read<MapViewBloc>().state.markers,
          polygonOptions: const PolygonOptions(
              borderColor: Colors.blueAccent,
              color: Colors.black12,
              borderStrokeWidth: 3),
          builder: (context, markers) {
            return FloatingActionButton(
              child: Text(markers.length.toString()),
              onPressed: null,
            );
          },
        ),
      ],
    );
  }
}
