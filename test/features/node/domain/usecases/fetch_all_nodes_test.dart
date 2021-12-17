// ignore_for_file: prefer_const_constructors

import 'package:built_collection/built_collection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wikiclimb_flutter_frontend/core/collections/page.dart';
import 'package:wikiclimb_flutter_frontend/core/error/failure.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/node.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/node_fetch_params.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/repositories/node_repository.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/usecases/fetch_all_nodes.dart';

import '../../../../fixtures/area/area_pages.dart';

class MockNodeRepository extends Mock implements NodeRepository {}

void main() {
  late NodeRepository mockNodeRepository;
  late FetchAllNodes fetchAllNodes;
  final tArea1 = Node((n) => n
    ..id = 1234
    ..type = 1
    ..name = 'test-area-1'
    ..description = 'test-area-description'
    ..createdBy = 'test-user'
    ..createdAt = 1636899203
    ..updatedBy = 'test-user'
    ..updatedAt = 1636899203);

  final tArea2 = Node((n) => n
    ..id = 123
    ..type = 1
    ..name = 'test-area-2'
    ..description = 'test-area-2-description'
    ..createdBy = 'test-user'
    ..createdAt = 1636899203
    ..updatedBy = 'test-user'
    ..updatedAt = 1636899203);

  Page<Node> page1 = Page((p) => p
    ..items = ListBuilder([tArea1, tArea2])
    ..pageNumber = 1
    ..nextPageNumber = 2
    ..isLastPage = false);
  Page<Node> emptyPage = Page((p) => p
    ..items = ListBuilder([])
    ..pageNumber = 1
    ..nextPageNumber = 2
    ..isLastPage = false);

  setUp(() {
    mockNodeRepository = MockNodeRepository();
    fetchAllNodes = FetchAllNodes(repository: mockNodeRepository);
  });

  test('should pipe area stream values', () async {
    when(() => mockNodeRepository.subscribe)
        .thenAnswer((_) => Stream.value(Right(page1)));
    expectLater(
      fetchAllNodes.subscribe,
      emitsInOrder([Right(page1)]),
    );
  });

  test('empty pages should be accepted', () async {
    when(() => mockNodeRepository.subscribe)
        .thenAnswer((_) => Stream.value(Right(emptyPage)));
    expectLater(
      fetchAllNodes.subscribe,
      emitsInOrder([Right(emptyPage)]),
    );
  });

  test('should return failure when repository fails', () async {
    when(() => mockNodeRepository.subscribe).thenAnswer(
      (_) => Stream.fromIterable([
        Right(page1),
        Left(NetworkFailure()),
      ]),
    );
    expectLater(
      fetchAllNodes.subscribe,
      emitsInOrder([
        Right(page1),
        Left(NetworkFailure()),
      ]),
    );
  });

  test(
    'should forward fetchPage calls',
    () {
      final tAreaPage = areaPages.first;
      final tParams = NodeFetchParams((p) => p
        ..page = 3
        ..parentId = 4
        ..perPage = 20);
      when(() => mockNodeRepository.fetchPage(tParams))
          .thenAnswer((_) async => Right(tAreaPage));
      fetchAllNodes.fetchPage(params: tParams);
      verify(() => mockNodeRepository.fetchPage(tParams)).called(1);
    },
  );

  test(
    'should forward fetchPage calls with default parameters',
    () {
      final tAreaPage = areaPages.first;
      final tParams = NodeFetchParams((p) => p
        ..page = 1
        ..perPage = 20);
      when(() => mockNodeRepository.fetchPage(tParams))
          .thenAnswer((_) async => Right(tAreaPage));
      fetchAllNodes.fetchPage();
      verify(() => mockNodeRepository.fetchPage(tParams)).called(1);
    },
  );
}
