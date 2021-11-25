// ignore_for_file: prefer_const_constructors

import 'package:built_collection/built_collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wikiclimb_flutter_frontend/features/image/presentation/bloc/list/image_list_bloc.dart';

import '../../../../../fixtures/image/image_pages.dart';
import '../../../../../fixtures/node/nodes.dart';

void main() {
  group('ImageListState', () {
    test('initial state supports value comparison', () {
      expect(
          ImageListState(
            status: ImageListStatus.loading,
            images: BuiltSet(),
            hasError: false,
            nextPage: 1,
          ),
          ImageListState(
            status: ImageListStatus.loading,
            images: BuiltSet(),
            hasError: false,
            nextPage: 1,
          ));
      expect(
        ImageListState(
          status: ImageListStatus.loaded,
          images: BuiltSet(imagePages.first.items),
          hasError: false,
          nextPage: 3,
        ),
        ImageListState(
          status: ImageListStatus.loaded,
          images: BuiltSet(imagePages.first.items),
          hasError: false,
          nextPage: 3,
        ),
      );
    });
  });

  group('copy with', () {
    test('creates a new state with the updated values', () {
      final tNode = nodes.first;
      final initial = ImageListState(
        status: ImageListStatus.initial,
        images: BuiltSet(),
        hasError: false,
        nextPage: 1,
      );
      final expected = ImageListState(
        status: ImageListStatus.loading,
        images: BuiltSet(),
        hasError: false,
        nextPage: 1,
        node: tNode,
      );
      expect(
        initial.copyWith(status: ImageListStatus.loading, node: tNode),
        expected,
      );
      expect(
        initial.copyWith(node: tNode),
        isNot(equals(initial)),
      );
    });
  });
}
