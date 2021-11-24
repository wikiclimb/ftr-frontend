import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/collections/page.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/image.dart';
import '../../domain/repository/image_repository.dart';
import '../datasources/image_remote_data_source.dart';

/// Provides implementations to the methods exposed on [ImageRepository].
class ImageRepositoryImpl with ExceptionHandler implements ImageRepository {
  ImageRepositoryImpl(ImageRemoteDataSource remoteDataSource)
      : _remoteDataSource = remoteDataSource;

  final ImageRemoteDataSource _remoteDataSource;
  final _controller =
      StreamController<Either<Failure, Page<Image>>>.broadcast();

  @override
  void dispose() {
    _controller.close();
  }

  @override
  Future<Either<Failure, Page<Image>>> fetchPage(
      {Map<String, dynamic>? params}) async {
    try {
      final imageModelPage = await _remoteDataSource.fetchAll(params ?? {});
      final imagePage = Page<Image>(
        (p) => p
          ..isLastPage = imageModelPage.isLastPage
          ..nextPageNumber = imageModelPage.nextPageNumber
          ..pageNumber = imageModelPage.pageNumber
          ..items = ListBuilder(imageModelPage.items.map((nm) => nm.toImage())),
      );
      _controller.add(Right(imagePage));
      return Right(imagePage);
    } on Exception catch (e) {
      final Left<Failure, Page<Image>> result = Left(exceptionToFailure(e));
      _controller.add(result);
      return result;
    }
  }

  @override
  Stream<Either<Failure, Page<Image>>> get subscribe async* {
    yield* _controller.stream;
  }
}
