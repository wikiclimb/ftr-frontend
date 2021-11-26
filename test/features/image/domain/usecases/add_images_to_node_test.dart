// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:built_collection/built_collection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wikiclimb_flutter_frontend/core/error/failure.dart';
import 'package:wikiclimb_flutter_frontend/features/image/domain/entities/image.dart';
import 'package:wikiclimb_flutter_frontend/features/image/domain/repository/image_repository.dart';
import 'package:wikiclimb_flutter_frontend/features/image/domain/usecases/add_images_to_node.dart';

import '../../../../fixtures/image/images.dart';

class MockImageRepository extends Mock implements ImageRepository {}

class MockFile extends Mock implements File {}

void main() {
  late ImageRepository mockImageRepository;
  late AddImagesToNode usecase;
  final tPaths = ['path', 'path2', 'path3'];
  final tParams = Params(
    filePaths: tPaths,
    nodeId: 1,
    name: 'name',
    description: 'description',
  );

  setUpAll(() {
    mockImageRepository = MockImageRepository();
    usecase = AddImagesToNode(mockImageRepository);
  });

  test('success call', () async {
    final expected = Right<Failure, BuiltList<Image>>(BuiltList(images));
    when(() => mockImageRepository.create(tParams))
        .thenAnswer((_) async => expected);
    final result = await usecase(tParams);
    expect(result, expected);
    verify(() => mockImageRepository.create(tParams)).called(1);
    verifyNoMoreInteractions(mockImageRepository);
  });

  test('failure call', () async {
    final expected = Left<Failure, BuiltList<Image>>(NetworkFailure());
    when(() => mockImageRepository.create(tParams))
        .thenAnswer((_) async => expected);
    final result = await usecase(tParams);
    expect(result, expected);
    verify(() => mockImageRepository.create(tParams)).called(1);
    verifyNoMoreInteractions(mockImageRepository);
  });

  test('params value equality', () {
    expect(tParams.props, unorderedEquals([tPaths, 1, 'name', 'description']));
  });
}
