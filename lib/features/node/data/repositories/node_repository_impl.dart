import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/collections/page.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/node.dart';
import '../../domain/repositories/node_repository.dart';
import '../datasources/node_remote_data_source.dart';

/// Provides implementations to the methods exposed on [NodeRepository].
class NodeRepositoryImpl implements NodeRepository {
  NodeRepositoryImpl({required this.remoteDataSource});

  final NodeRemoteDataSource remoteDataSource;

  final _controller = StreamController<Either<Failure, Page<Node>>>();

  @override
  // TODO: implement subscribe
  Stream<Either<Failure, Page<Node>>> get subscribe async* {
    yield* _controller.stream;
  }

  @override
  Future<Either<Failure, Node>> create(Node node) {
    // TODO: implement create
    throw UnimplementedError();
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
  void fetchPage({Map<String, dynamic>? params}) async {
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
    } catch (_) {}
  }

  @override
  Future<Either<Failure, Node>> one(int id) {
    // TODO: implement one
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Node>> update(Node node) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
