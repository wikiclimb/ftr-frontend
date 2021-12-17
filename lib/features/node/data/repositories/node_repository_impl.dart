import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/collections/page.dart';
import '../../../../core/database/database.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/node.dart';
import '../../domain/entities/node_fetch_params.dart';
import '../../domain/repositories/node_repository.dart';
import '../converters/node_page_converter.dart';
import '../datasources/node_local_data_source.dart';
import '../datasources/node_remote_data_source.dart';
import '../models/node_model.dart';

/// Provides implementations to the methods exposed on [NodeRepository].
class NodeRepositoryImpl with ExceptionHandler implements NodeRepository {
  NodeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final NodeRemoteDataSource remoteDataSource;
  final NodeLocalDataSource localDataSource;

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
  Future<Either<Failure, Page<Node>>> fetchPage(NodeFetchParams params) async {
    try {
      // Return from database
      final driftNodesPage = await localDataSource.fetchAll(params);
      // Add the page to the controller but only return network responses
      _controller
          .add(Right(NodePageConverter.nodeFromDriftNode(driftNodesPage)));
      final nodeModelsPage = await remoteDataSource.fetchAll(params);
      localDataSource.saveAll(BuiltList<DriftNode>(
          nodeModelsPage.items.map((nm) => nm.toDriftNode())));
      final nodePage = NodePageConverter.nodeFromNodeModel(nodeModelsPage);
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
