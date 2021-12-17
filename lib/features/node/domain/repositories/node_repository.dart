import 'package:dartz/dartz.dart';

import '../../../../core/collections/page.dart';
import '../../../../core/error/failure.dart';
import '../../../node/domain/entities/node.dart';
import '../entities/node_fetch_params.dart';

/// Provides contracts to interact with node data.
abstract class NodeRepository {
  /// Subscribe to a stream of [Node] data.
  Stream<Either<Failure, Page<Node>>> get subscribe;

  /// Push one page of data to the stream, with the given parameters.
  ///
  /// The method also returns the given page in case the consumer does not want
  /// to subscribe to the [Stream].
  Future<Either<Failure, Page<Node>>> fetchPage(NodeFetchParams params);

  /// Fetch data for one [Node].
  Future<Either<Failure, Node>> one(int id);

  /// Update a [Node]'s values.
  Future<Either<Failure, Node>> update(Node node);

  /// Create a new [Node] with the given data.
  Future<Either<Failure, Node>> create(Node node);

  /// Delete the given [Node].
  Future<Either<Failure, bool>> delete(Node node);

  /// Clear up resources created by this repository.
  void dispose();
}
