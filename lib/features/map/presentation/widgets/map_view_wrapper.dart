import 'package:flutter/material.dart';

import 'map_view.dart';

/// Wraps a [MapView] widget in a [Scaffold] and it gives it an [AppBar].
///
/// This widget can be further customized to hide the [AppBar] while the user
/// is interacting with the map and only show it when needed, for example
/// reacting to the user tapping the map.
class MapViewWrapper extends StatelessWidget {
  const MapViewWrapper({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        shadowColor: Colors.black,
        title: const Text('WikiClimb'),
        // backgroundColor: Colors.transparent,
        backgroundColor: const Color(0x33000000),
        elevation: 0,
      ),
      body: MapView(),
    );
  }
}
