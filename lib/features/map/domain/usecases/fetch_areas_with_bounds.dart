import 'package:built_collection/built_collection.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../../area/domain/repository/area_repository.dart';
import '../../../area/domain/usecases/fetch_all.dart';
import '../../../node/domain/entities/node.dart';

/// Paged subscription that fetches areas within some geographical bounds.
///
/// This class is a thin wrapper around [FetchAllAreas] that extends its
/// functionality by letting the user call the method passing directly
/// a [MapPosition] and a [Set] of [Node]s already fetched previously.
class FetchAreasWithBounds extends FetchAllAreas {
  FetchAreasWithBounds({required AreaRepository repository})
      : super(repository: repository);

  final maxNodesFetched = 1000;

  void fetch({
    required MapPosition position,
    required BuiltSet<Node> nodes,
    Map<String, String>? params,
  }) {
    final bounds = position.bounds;
    if (bounds == null) {
      // Ignore calls where bounds are null.
      return;
    }
    final Map<String, String> _params = {
      'north': bounds.north.toString(),
      'east': bounds.east.toString(),
      'south': bounds.south.toString(),
      'west': bounds.west.toString(),
      'exclude': nodes.map((n) => n.id).join(','),
      'bounded': 'true',
      'per-page': maxNodesFetched.toString(),
    };
    if (params != null) {
      _params.addAll(params);
    }
    super.fetchPage(params: _params);
  }
}
