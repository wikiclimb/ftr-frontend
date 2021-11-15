import 'package:dartz/dartz.dart';

import '../../../../core/collections/page.dart';
import '../../../../core/error/failure.dart';
import '../../../node/domain/entities/node.dart';
import '../../../node/domain/repositories/node_repository.dart';
import '../../domain/repository/area_repository.dart';

class AreaRepositoryImpl extends AreaRepository {
  AreaRepositoryImpl({required this.nodeRepository});

  final NodeRepository nodeRepository;

  @override
  Future<Either<Failure, Node>> create(Node node) =>
      nodeRepository.create(node);

  @override
  Future<Either<Failure, bool>> delete(Node node) =>
      nodeRepository.delete(node);

  @override
  void dispose() => nodeRepository.dispose();

  @override
  void fetchPage({Map<String, String>? params, int? page}) {
    Map<String, String> newParams = {'type': '1'};
    newParams.addAll(params ?? {});
    return nodeRepository.fetchPage(params: newParams, page: page);
  }

  @override
  Future<Either<Failure, Node>> one(int id) => nodeRepository.one(id);

  @override
  Stream<Either<Failure, Page<Node>>> get subscribe => nodeRepository.subscribe;

  @override
  Future<Either<Failure, Node>> update(Node node) =>
      nodeRepository.update(node);
}
