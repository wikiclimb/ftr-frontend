import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:wikiclimb_flutter_frontend/features/node/data/datasources/node_remote_data_source.dart';
import 'package:wikiclimb_flutter_frontend/features/node/data/repositories/node_repository_impl.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/repositories/node_repository.dart';

import '../../../../fixtures/node/node_model_pages.dart';
import '../../../../fixtures/node/node_pages.dart';

class MockRemoteDataSource extends Mock implements NodeRemoteDataSource {}

void main() {
  late NodeRemoteDataSource mockRemoteDataSource;
  late NodeRepository repository;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    repository = NodeRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  group('create', () {});

  group('delete', () {});

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

    // test('Unauthorized failure', () async {
    //   when(() => mockRemoteDataSource.fetchAll(any()))
    //       .thenThrow((_) => UnauthorizedException());
    //   expectLater(
    //     repository.subscribe,
    //     emitsInOrder([Left(UnauthorizedFailure())]),
    //   );
    //   repository.fetchPage(params: {});
    //   verify(() => mockRemoteDataSource.fetchAll(any())).called(1);
    // });

    // test('Forbidden failure', () async {
    //   when(() => mockRemoteDataSource.fetchAll({}))
    //       .thenThrow(ForbiddenException());
    //   expectLater(
    //     repository.subscribe,
    //     emitsInOrder([Left(ForbiddenFailure())]),
    //   );
    //   repository.fetchPage();
    //   verify(() => mockRemoteDataSource.fetchAll({})).called(1);
    // });

    // test('Server failure', () async {
    //   when(() => mockRemoteDataSource.fetchAll({}))
    //       .thenThrow(ServerException());
    //   expectLater(
    //     repository.subscribe,
    //     emitsInOrder([Left(ServerFailure())]),
    //   );
    //   repository.fetchPage();
    //   verify(() => mockRemoteDataSource.fetchAll({})).called(1);
    // });

    // test('Network failure', () async {
    //   when(() => mockRemoteDataSource.fetchAll({}))
    //       .thenThrow(NetworkException());
    //   expectLater(
    //     repository.subscribe,
    //     emitsInOrder([Left(NetworkFailure())]),
    //   );
    //   repository.fetchPage();
    //   verify(() => mockRemoteDataSource.fetchAll({})).called(1);
    // });

    // test('Application failure', () async {
    //   when(() => mockRemoteDataSource.fetchAll({}))
    //       .thenThrow(ApplicationException());
    //   expectLater(
    //     repository.subscribe,
    //     emitsInOrder([Left(ApplicationFailure())]),
    //   );
    //   repository.fetchPage();
    //   verify(() => mockRemoteDataSource.fetchAll({})).called(1);
    // });
  });

  group('one', () {});

  group('subscriptions', () {});

  group('update', () {});
}
