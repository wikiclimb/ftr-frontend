import 'package:wikiclimb_flutter_frontend/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:wikiclimb_flutter_frontend/core/usecases/usecase.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/node.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/repositories/node_repository.dart';

/// Edit node use case lets callers update a node's details.
///
/// This use case can take an instance of a [Node] just created, that does not
/// exist in the server yet, or an existing instance, and deal with
/// them correctly.
class EditNode extends UseCase<Node, Node> {
  EditNode(this.repository);

  final NodeRepository repository;

  @override
  Future<Either<Failure, Node>> call(Node params) async {
    // If the ID is null this [Node] does not exist in the server.
    if (params.id == null) {
      return await repository.create(params);
    } else {
      return await repository.update(params);
    }
  }
}
