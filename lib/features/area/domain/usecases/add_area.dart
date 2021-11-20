import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../node/domain/entities/node.dart';
import '../repository/area_repository.dart';

/// Contract class for the add area use case.
class AddArea extends UseCase<Node, Node> {
  AddArea(this.repository);

  final AreaRepository repository;

  @override
  Future<Either<Failure, Node>> call(Node params) {
    return repository.create(params);
  }
}
