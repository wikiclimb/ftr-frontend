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
  });

  group('one', () {});

  group('subscriptions', () {});

  group('update', () {});
}
