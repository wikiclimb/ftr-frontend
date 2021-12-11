// ignore_for_file: prefer_const_constructors

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wikiclimb_flutter_frontend/core/error/exception.dart';
import 'package:wikiclimb_flutter_frontend/core/error/failure.dart';
import 'package:wikiclimb_flutter_frontend/features/node/data/datasources/node_local_data_source.dart';
import 'package:wikiclimb_flutter_frontend/features/node/data/datasources/node_remote_data_source.dart';
import 'package:wikiclimb_flutter_frontend/features/node/data/models/node_model.dart';
import 'package:wikiclimb_flutter_frontend/features/node/data/repositories/node_repository_impl.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/repositories/node_repository.dart';

import '../../../../fixtures/node/node_model_pages.dart';
import '../../../../fixtures/node/node_pages.dart';
import '../../../../fixtures/node/nodes.dart';

class MockRemoteDataSource extends Mock implements NodeRemoteDataSource {}

class MockLocalDataSource extends Mock implements NodeLocalDataSource {}

void main() {
  late NodeRemoteDataSource mockRemoteDataSource;
  late NodeLocalDataSource mockLocalDataSource;
  late NodeRepository repository;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    repository = NodeRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  group('create', () {
    test('successful create returns created node instance', () async {
      final tNode = nodes.first;
      final tParam = NodeModel.fromNode(tNode).rebuild((n) => n..id = null);
      final tNodeModel = NodeModel.fromNode(tNode);
      when(() => mockRemoteDataSource.create(tParam))
          .thenAnswer((_) async => tNodeModel);
      final result =
          await repository.create(tNode.rebuild((p0) => p0.id = null));
      expect(result, Right(tNode));
      verify(() => mockRemoteDataSource.create(tParam)).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('failed create converts exception to failure', () async {
      final tNode = nodes.first;
      final tParam = NodeModel.fromNode(tNode).rebuild((n) => n..id = null);
      when(() => mockRemoteDataSource.create(tParam))
          .thenThrow(ServerException());
      final result =
          await repository.create(tNode.rebuild((p0) => p0.id = null));
      expect(result, Left(ServerFailure()));
      verify(() => mockRemoteDataSource.create(tParam)).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });

  group('delete', () {
    test('should throw unimplemented', () {
      expect(
        () => repository.delete(nodes.first),
        throwsA(TypeMatcher<UnimplementedError>()),
      );
    });
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
      final tNodeModelPage = nodeModelPages.first;
      final tNodePage = nodePages.first;
      when(() => mockRemoteDataSource.fetchAll({}))
          .thenAnswer((_) async => tNodeModelPage);
      expectLater(
        repository.subscribe,
        emitsInOrder([Right(tNodePage)]),
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
      repository.fetchPage(params: {});
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
      when(() => mockRemoteDataSource.fetchAll(any())).thenAnswer(
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

  group('one', () {
    test('should throw unimplemented', () {
      expect(
        () => repository.one(1),
        throwsA(TypeMatcher<UnimplementedError>()),
      );
    });
  });

  group('subscriptions', () {});

  group('update', () {
    test('returns updated node instance if successful', () async {
      final tNode = nodes.first;
      final tParam = NodeModel.fromNode(tNode);
      final tNodeModel = NodeModel.fromNode(tNode);
      when(() => mockRemoteDataSource.update(tParam))
          .thenAnswer((_) async => tNodeModel);
      final result = await repository.update(tNode);
      expect(result, Right(tNode));
      verify(() => mockRemoteDataSource.update(tParam)).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('returns failure matching failure if failed', () async {
      final tNode = nodes.first;
      final tParam = NodeModel.fromNode(tNode);
      when(() => mockRemoteDataSource.update(tParam))
          .thenThrow(NetworkException());
      final result = await repository.update(tNode);
      expect(result, Left(NetworkFailure()));
      verify(() => mockRemoteDataSource.update(tParam)).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });
}
