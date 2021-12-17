import 'package:dartz/dartz.dart';

import '../../../../core/collections/page.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/paged_subscription.dart';
import '../../../node/domain/entities/node.dart';
import '../entities/node_fetch_params.dart';
import '../repositories/node_repository.dart';

/// Fetch all [Node] items based on the [NodeFetchParams] criteria.
class FetchAllNodes extends PagedSubscription<Node, NodeFetchParams> {
  FetchAllNodes({required NodeRepository repository})
      : _repository = repository;

  final NodeRepository _repository;

  @override
  Stream<Either<Failure, Page<Node>>> get subscribe async* {
    yield* _repository.subscribe;
  }

  @override
  void fetchPage({NodeFetchParams? params}) {
    _repository.fetchPage(params ??
        NodeFetchParams((p) => p
          ..page = 1
          ..perPage = 20));
  }
}
