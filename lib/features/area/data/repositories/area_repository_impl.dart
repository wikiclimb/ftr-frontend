import 'package:dartz/dartz.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/node_fetch_params.dart';

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
  Future<Either<Failure, Page<Node>>> fetchPage(
      {Map<String, String>? params, int? page}) {
    Map<String, String> newParams = {'type': '1'};
    newParams.addAll(params ?? {});
    final nfp = NodeFetchParams((p) => p
      ..type = 1
      ..query = params?['q']
      ..page = int.parse(params?['page'] ?? '1')
      ..perPage = int.parse(params?['per-page'] ?? '20')
      ..parentId = int.tryParse(params?['parent-id'] ?? ''));

    return nodeRepository.fetchPage(nfp);
  }

  @override
  Future<Either<Failure, Node>> one(int id) => nodeRepository.one(id);

  @override
  Stream<Either<Failure, Page<Node>>> get subscribe => nodeRepository.subscribe;

  @override
  Future<Either<Failure, Node>> update(Node node) =>
      nodeRepository.update(node);
}
