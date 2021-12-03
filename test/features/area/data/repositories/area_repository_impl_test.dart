// ignore_for_file: prefer_const_constructors

import 'package:built_collection/built_collection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wikiclimb_flutter_frontend/core/collections/page.dart';
import 'package:wikiclimb_flutter_frontend/core/error/failure.dart';
import 'package:wikiclimb_flutter_frontend/features/area/data/repositories/area_repository_impl.dart';

import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/node.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/repositories/node_repository.dart';

import '../../../../fixtures/node/node_pages.dart';
import '../../../../fixtures/node/nodes.dart';

class MockNodeRepository extends Mock implements NodeRepository {}

void main() {
  late MockNodeRepository mockNodeRepository;
  late AreaRepositoryImpl repository;
  final tArea1 = nodes.elementAt(1);
  final tArea2 = nodes.elementAt(2);

  Page<Node> page1 = Page((p) => p
    ..items = ListBuilder([tArea1, tArea2])
    ..pageNumber = 1
    ..nextPageNumber = 2
    ..isLastPage = false);
  Page<Node> emptyPage = Page((p) => p
    ..items = ListBuilder([])
    ..pageNumber = 1
    ..nextPageNumber = -1
    ..isLastPage = true);

  setUp(() {
    mockNodeRepository = MockNodeRepository();
    repository = AreaRepositoryImpl(
      nodeRepository: mockNodeRepository,
    );
  });

  test('should pipe area stream values', () async {
    when(() => mockNodeRepository.subscribe).thenAnswer(
      (_) => Stream.fromIterable([Right(page1), Right(emptyPage)]),
    );
    expectLater(
      repository.subscribe,
      emitsInOrder([Right(page1), Right(emptyPage)]),
    );
  });

  test('empty pages should be accepted', () async {
    when(() => mockNodeRepository.subscribe)
        .thenAnswer((_) => Stream.value(Right(emptyPage)));
    expectLater(
      repository.subscribe,
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
      repository.subscribe,
      emitsInOrder([
        Right(page1),
        Left(NetworkFailure()),
      ]),
    );
  });

  test(
    'should forward fetchPage calls adding type 1 '
    'for area to the parameters',
    () {
      final tNodePage = nodePages.first;
      when(() => mockNodeRepository.fetchPage(params: any(named: 'params')))
          .thenAnswer((_) async => Right(tNodePage));
      repository.fetchPage();
      verify(
        () => mockNodeRepository.fetchPage(
          params: {'type': '1'},
        ),
      ).called(1);
      verifyNoMoreInteractions(mockNodeRepository);
    },
  );

  test(
    'should forward fetchPage call parameters and page '
    'adding type 1 for area to the parameters',
    () {
      final tNodePage = nodePages.first;
      when(() => mockNodeRepository.fetchPage(params: any(named: 'params')))
          .thenAnswer((_) async => Right(tNodePage));
      repository.fetchPage(
        params: {'q': 'test', 'page': '3'},
        page: 3,
      );
      verify(() => mockNodeRepository.fetchPage(
            params: {'type': '1', 'q': 'test', 'page': '3'},
          )).called(1);
      verifyNoMoreInteractions(mockNodeRepository);
    },
  );

  test('forward create calls to node repository', () async {
    final expected = nodes.elementAt(2);
    final tNodeParam = expected.rebuild((n) => n..id = null);
    when(() => mockNodeRepository.create(tNodeParam))
        .thenAnswer((_) async => Right(expected));
    final result = await repository.create(tNodeParam);
    expect(result, Right(expected));
    verify(() => mockNodeRepository.create(tNodeParam)).called(1);
    verifyNoMoreInteractions(mockNodeRepository);
  });

  test('forward delete calls to node repository', () async {
    final tNode = nodes.elementAt(2);
    when(() => mockNodeRepository.delete(tNode))
        .thenAnswer((_) async => Right(true));
    final result = await repository.delete(tNode);
    expect(result, Right(true));
    verify(() => mockNodeRepository.delete(tNode)).called(1);
    verifyNoMoreInteractions(mockNodeRepository);
  });

  test('forward one calls to node repository', () async {
    final tNode = nodes.elementAt(1);
    when(() => mockNodeRepository.one(1)).thenAnswer((_) async => Right(tNode));
    final result = await repository.one(1);
    expect(result, Right(tNode));
    verify(() => mockNodeRepository.one(1)).called(1);
    verifyNoMoreInteractions(mockNodeRepository);
  });

  test('forward update calls to node repository', () async {
    final tNode = nodes.elementAt(2);
    when(() => mockNodeRepository.update(tNode))
        .thenAnswer((_) async => Right(tNode));
    final result = await repository.update(tNode);
    expect(result, Right(tNode));
    verify(() => mockNodeRepository.update(tNode)).called(1);
    verifyNoMoreInteractions(mockNodeRepository);
  });

  test('forward dispose calls to node repository', () {
    repository.dispose();
    verify(() => mockNodeRepository.dispose()).called(1);
    verifyNoMoreInteractions(mockNodeRepository);
  });
}
