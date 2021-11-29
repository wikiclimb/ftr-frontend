// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:built_collection/built_collection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wikiclimb_flutter_frontend/core/error/failure.dart';
import 'package:wikiclimb_flutter_frontend/features/image/domain/entities/image.dart';
import 'package:wikiclimb_flutter_frontend/features/image/domain/usecases/add_images_to_node.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/bloc/add_node_images/add_node_images_bloc.dart';

import '../../../../../fixtures/image/images.dart';
import '../../../../../fixtures/image/xfiles.dart';
import '../../../../../fixtures/node/nodes.dart';

class MockAddImagesToNode extends Mock implements AddImagesToNode {}

void main() {
  late AddImagesToNode usecase;
  final List<String> tFilePaths = [
    'oo',
  ].toList();
  final tImage = images.first;
  final tImages = BuiltList<Image>([tImage]);
  final tFile = xFiles.first;
  final tFiles = BuiltList<XFile>([tFile]);
  final tNode = nodes.first;

  setUpAll(() {
    registerFallbackValue(Params(filePaths: tFilePaths, nodeId: 1));
    usecase = MockAddImagesToNode();
  });

  test('initial state', () {
    final bloc = AddNodeImagesBloc(usecase);
    expect(bloc.state, AddNodeImagesState());
  });

  group('success', () {
    blocTest<AddNodeImagesBloc, AddNodeImagesState>(
      'emits correctly',
      setUp: () =>
          when(() => usecase(any())).thenAnswer((_) async => Right(tImages)),
      build: () => AddNodeImagesBloc(usecase),
      act: (bloc) {
        bloc.add(ImagesSelected(files: tFiles, node: tNode));
      },
      expect: () => <AddNodeImagesState>[
        AddNodeImagesState(status: AddNodeImagesStatus.sending),
        AddNodeImagesState(
            status: AddNodeImagesStatus.success, images: tImages),
      ],
      verify: (_) {
        verify(() => usecase(any())).called(1);
        verifyNoMoreInteractions(usecase);
      },
    );
  });
  group('failure', () {
    blocTest<AddNodeImagesBloc, AddNodeImagesState>(
      'emits correctly',
      setUp: () => when(() => usecase(any()))
          .thenAnswer((_) async => Left(ApplicationFailure())),
      build: () => AddNodeImagesBloc(usecase),
      act: (bloc) {
        bloc.add(ImagesSelected(files: tFiles, node: tNode));
      },
      expect: () => <AddNodeImagesState>[
        AddNodeImagesState(status: AddNodeImagesStatus.sending),
        AddNodeImagesState(status: AddNodeImagesStatus.error, images: null),
      ],
      verify: (_) {
        verify(() => usecase(any())).called(1);
        verifyNoMoreInteractions(usecase);
      },
    );
  });
}
