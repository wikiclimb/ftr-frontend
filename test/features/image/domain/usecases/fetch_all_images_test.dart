// ignore_for_file: prefer_const_constructors

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wikiclimb_flutter_frontend/core/error/failure.dart';
import 'package:wikiclimb_flutter_frontend/features/image/domain/repository/image_repository.dart';
import 'package:wikiclimb_flutter_frontend/features/image/domain/usecases/fetch_all_images.dart';

import '../../../../fixtures/image/image_pages.dart';

class MockImageRepository extends Mock implements ImageRepository {}

void main() {
  late ImageRepository mockImageRepository;
  late FetchAllImages fetchAllImages;

  setUp(() {
    mockImageRepository = MockImageRepository();
    fetchAllImages = FetchAllImages(mockImageRepository);
  });

  test('should pipe image stream values', () async {
    final tPage = imagePages.first;
    when(() => mockImageRepository.subscribe)
        .thenAnswer((_) => Stream.value(Right(tPage)));
    expectLater(
      fetchAllImages.subscribe,
      emitsInOrder([Right(tPage)]),
    );
  });

  test('empty pages should be accepted', () async {
    final tEmptyPage = imagePages.elementAt(1);
    when(() => mockImageRepository.subscribe)
        .thenAnswer((_) => Stream.value(Right(tEmptyPage)));
    expectLater(
      fetchAllImages.subscribe,
      emitsInOrder([Right(tEmptyPage)]),
    );
  });

  test('should return failure when repository fails', () async {
    final tPage = imagePages.first;
    when(() => mockImageRepository.subscribe).thenAnswer(
      (_) => Stream.fromIterable([
        Right(tPage),
        Left(NetworkFailure()),
      ]),
    );
    expectLater(
      fetchAllImages.subscribe,
      emitsInOrder([
        Right(tPage),
        Left(NetworkFailure()),
      ]),
    );
  });

  test(
    'should forward fetchPage calls',
    () {
      final tPage = imagePages.first;
      when(() => mockImageRepository.fetchPage())
          .thenAnswer((_) async => Right(tPage));
      fetchAllImages.fetchPage();
      verify(() => mockImageRepository.fetchPage()).called(1);
    },
  );
}
