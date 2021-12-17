// ignore_for_file: prefer_const_constructors

import 'package:built_collection/built_collection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wikiclimb_flutter_frontend/core/collections/page.dart';
import 'package:wikiclimb_flutter_frontend/core/error/failure.dart';

import 'package:wikiclimb_flutter_frontend/features/area/domain/repository/area_repository.dart';
import 'package:wikiclimb_flutter_frontend/features/area/domain/usecases/fetch_all.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/node.dart';

import '../../../../fixtures/area/area_pages.dart';

class MockAreaRepository extends Mock implements AreaRepository {}

void main() {
  late AreaRepository mockAreaRepository;
  late FetchAllAreas fetchAllAreas;
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
    mockAreaRepository = MockAreaRepository();
    fetchAllAreas = FetchAllAreas(repository: mockAreaRepository);
  });

  test('should pipe area stream values', () async {
    when(() => mockAreaRepository.subscribe)
        .thenAnswer((_) => Stream.value(Right(page1)));
    expectLater(
      fetchAllAreas.subscribe,
      emitsInOrder([Right(page1)]),
    );
  });

  test('empty pages should be accepted', () async {
    when(() => mockAreaRepository.subscribe)
        .thenAnswer((_) => Stream.value(Right(emptyPage)));
    expectLater(
      fetchAllAreas.subscribe,
      emitsInOrder([Right(emptyPage)]),
    );
  });

  test('should return failure when repository fails', () async {
    when(() => mockAreaRepository.subscribe).thenAnswer(
      (_) => Stream.fromIterable([
        Right(page1),
        Left(NetworkFailure()),
      ]),
    );
    expectLater(
      fetchAllAreas.subscribe,
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
      when(() => mockAreaRepository.fetchPage())
          .thenAnswer((_) async => Right(tAreaPage));
      fetchAllAreas.fetchPage();
      verify(() => mockAreaRepository.fetchPage()).called(1);
    },
  );
}
