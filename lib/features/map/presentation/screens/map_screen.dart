import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../di.dart';
import '../bloc/map_view/map_view_bloc.dart';
import '../widgets/map_view_wrapper.dart';

/// Manages a route that renders a map with WikiClimb data.
///
/// This widget is in charge of instantiating a map widget and providing it
/// with a [MapViewBloc].
class MapScreen extends StatelessWidget {
  const MapScreen({Key? key}) : super(key: key);

  static const String id = '/map';

  static Route route() =>
      MaterialPageRoute<void>(builder: (_) => const MapScreen());

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MapViewBloc>(
      create: (context) => sl<MapViewBloc>(),
      child: const MapViewWrapper(),
    );
  }
}
