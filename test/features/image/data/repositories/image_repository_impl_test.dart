// ignore_for_file: prefer_const_constructors

import 'package:built_collection/built_collection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wikiclimb_flutter_frontend/core/error/exception.dart';
import 'package:wikiclimb_flutter_frontend/core/error/failure.dart';
import 'package:wikiclimb_flutter_frontend/features/image/data/datasources/image_remote_data_source.dart';
import 'package:wikiclimb_flutter_frontend/features/image/data/models/image_model.dart';
import 'package:wikiclimb_flutter_frontend/features/image/data/repositories/image_repository_impl.dart';
import 'package:wikiclimb_flutter_frontend/features/image/domain/entities/image.dart';
import 'package:wikiclimb_flutter_frontend/features/image/domain/repository/image_repository.dart';
import 'package:wikiclimb_flutter_frontend/features/image/domain/usecases/add_images_to_node.dart';

import '../../../../fixtures/image/image_model_pages.dart';
import '../../../../fixtures/image/image_models.dart';
import '../../../../fixtures/image/image_pages.dart';

class MockRemoteDataSource extends Mock implements ImageRemoteDataSource {}

void main() {
  late ImageRemoteDataSource mockRemoteDataSource;
  late ImageRepository repository;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    repository = ImageRepositoryImpl(mockRemoteDataSource);
  });

  group('dispose', () {
    test('close the stream on dispose', () async {
      expectLater(
        repository.subscribe,
        emitsInOrder([emitsDone]),
      );
      repository.dispose();
    });
  });

  group('fetchPage', () {
    test('repository stream pipes values when requested', () async {
      final tImageModelPage = imageModelPages.first;
      final tImagePage = imagePages.first;
      when(() => mockRemoteDataSource.fetchAll({}))
          .thenAnswer((_) async => tImageModelPage);
      expectLater(
        repository.subscribe,
        emitsInOrder([Right(tImagePage)]),
      );
      repository.fetchPage();
      verify(() => mockRemoteDataSource.fetchAll({})).called(1);
    });

    test('Unauthorized failure', () async {
      when(() => mockRemoteDataSource.fetchAll(any()))
          .thenAnswer((_) async => throw UnauthorizedException());
      expectLater(
        repository.subscribe,
        emitsInOrder([Left(UnauthorizedFailure())]),
      );
      repository.fetchPage();
      verify(() => mockRemoteDataSource.fetchAll(any())).called(1);
    });

    test('Forbidden failure', () async {
      when(() => mockRemoteDataSource.fetchAll({}))
          .thenAnswer((_) async => throw ForbiddenException());
      expectLater(
        repository.subscribe,
        emitsInOrder([Left(ForbiddenFailure())]),
      );
      repository.fetchPage();
      verify(() => mockRemoteDataSource.fetchAll({})).called(1);
    });

    test('Server failure', () async {
      when(() => mockRemoteDataSource.fetchAll({}))
          .thenAnswer((_) async => throw ServerException());
      expectLater(
        repository.subscribe,
        emitsInOrder([Left(ServerFailure())]),
      );
      repository.fetchPage();
      verify(() => mockRemoteDataSource.fetchAll({})).called(1);
    });

    test('Network failure', () async {
      when(() => mockRemoteDataSource.fetchAll({})).thenAnswer(
        (_) async => throw NetworkException(),
      );
      expectLater(
        repository.subscribe,
        emits(Left(NetworkFailure())),
      );
      final result = await repository.fetchPage();
      expect(result, Left(NetworkFailure()));
      verify(() => mockRemoteDataSource.fetchAll({})).called(1);
    });

    test('Application failure', () async {
      when(() => mockRemoteDataSource.fetchAll({}))
          .thenAnswer((_) async => throw ApplicationException());
      expectLater(
        repository.subscribe,
        emitsInOrder([Left(ApplicationFailure())]),
      );
      repository.fetchPage();
      verify(() => mockRemoteDataSource.fetchAll({})).called(1);
    });
  });

  group('create', () {
    final tPaths = ['path', 'path2', 'path3'];
    final tParams = Params(
      filePaths: tPaths,
      nodeId: 1,
      name: 'name',
      description: 'description',
    );
    test('success converts to image', () async {
      final dataSourceReturn = BuiltList<ImageModel>(imageModels);
      final expected = Right<Failure, BuiltList<Image>>(
        BuiltList(dataSourceReturn.map((im) => im.toImage())),
      );
      when(() => mockRemoteDataSource.create(tParams))
          .thenAnswer((_) async => dataSourceReturn);
      final result = await repository.create(tParams);
      expect(result, expected);
    });

    test('failures are passed on', () async {
      when(() => mockRemoteDataSource.create(tParams))
          .thenAnswer((_) async => throw UnauthorizedException());
      final result = await repository.create(tParams);
      expect(result, Left(UnauthorizedFailure()));
    });
  });
}
