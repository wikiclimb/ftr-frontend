import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/collections/page.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/node.dart';
import '../../domain/repositories/node_repository.dart';
import '../datasources/node_remote_data_source.dart';
import '../models/node_model.dart';

/// Provides implementations to the methods exposed on [NodeRepository].
class NodeRepositoryImpl with ExceptionHandler implements NodeRepository {
  NodeRepositoryImpl({required this.remoteDataSource});

  final NodeRemoteDataSource remoteDataSource;

  final _controller = StreamController<Either<Failure, Page<Node>>>.broadcast();

  @override
  Stream<Either<Failure, Page<Node>>> get subscribe async* {
    yield* _controller.stream;
  }

  @override
  Future<Either<Failure, Node>> create(Node node) async {
    try {
      final response = await remoteDataSource.create(NodeModel.fromNode(node));
      return Right(response.toNode());
    } on Exception catch (e) {
      return Left(exceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, bool>> delete(Node node) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  void dispose() {
    _controller.close();
  }

  @override
  Future<Either<Failure, Page<Node>>> fetchPage(
      {Map<String, String>? params}) async {
    try {
      final nodeModelPage = await remoteDataSource.fetchAll(params ?? {});
      final nodePage = Page<Node>(
        (p) => p
          ..isLastPage = nodeModelPage.isLastPage
          ..nextPageNumber = nodeModelPage.nextPageNumber
          ..pageNumber = nodeModelPage.pageNumber
          ..items = ListBuilder(nodeModelPage.items.map((nm) => nm.toNode())),
      );
      _controller.add(Right(nodePage));
      return Right(nodePage);
    } on Exception catch (e) {
      final Left<Failure, Page<Node>> result = Left(exceptionToFailure(e));
      _controller.add(result);
      return result;
    }
  }

  @override
  Future<Either<Failure, Node>> one(int id) {
    // TODO: implement one
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Node>> update(Node node) async {
    try {
      final response = await remoteDataSource.update(NodeModel.fromNode(node));
      return Right(response.toNode());
    } on Exception catch (e) {
      return Left(exceptionToFailure(e));
    }
  }
}
