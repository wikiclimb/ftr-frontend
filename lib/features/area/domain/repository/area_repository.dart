import 'package:dartz/dartz.dart';

import '../../../../core/collections/page.dart';
import '../../../../core/error/failure.dart';
import '../../../node/domain/entities/node.dart';

/// Provides contracts to interact with area data.
abstract class AreaRepository {
  /// Subscribe to a stream of Area data.
  Stream<Either<Failure, Page<Node>>> get subscribe;

  /// Push one page of data to the subscription.
  void fetchPage({int? page});

  /// Fetch data for one area.
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
