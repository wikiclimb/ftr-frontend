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
    Map<String, dynamic>? params,
  }) {
    final bounds = position.bounds;
    if (bounds == null) {
      // Ignore calls where bounds are null.
      return;
    }
    final Map<String, dynamic> _params = {
      'north': bounds.north,
      'east': bounds.east,
      'south': bounds.south,
      'west': bounds.west,
      'exclude': nodes.map((n) => n.id),
      'bounded': true,
      'per-page': maxNodesFetched,
    };
    if (params != null) {
      _params.addAll(params);
    }
    super.fetchPage(params: _params);
  }
}
