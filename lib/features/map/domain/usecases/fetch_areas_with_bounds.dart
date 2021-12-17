import 'package:built_collection/built_collection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../../../core/collections/page.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/paged_subscription.dart';
import '../../../area/domain/repository/area_repository.dart';
import '../../../node/domain/entities/node.dart';

/// Paged subscription that fetches areas within some geographical bounds.
///
/// Allows fetching by area by letting the user call the method passing directly
/// a [MapPosition] and a [Set] of [Node]s already fetched previously.
class FetchAreasWithBounds
    extends PagedSubscription<Node, Map<String, String>> {
  FetchAreasWithBounds({required AreaRepository repository})
      : _repository = repository;

  final maxNodesFetched = 1000;
  final AreaRepository _repository;

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
    fetchPage(params: _params);
  }

  @override
  void fetchPage({Map<String, String>? params}) {
    _repository.fetchPage(params: params);
  }

  @override
  Stream<Either<Failure, Page<Node>>> get subscribe => _repository.subscribe;
}
