// ignore_for_file: prefer_const_constructors
import 'package:built_collection/built_collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wikiclimb_flutter_frontend/features/area/presentation/bloc/list/areas_bloc.dart';

import '../../../../../fixtures/node/nodes.dart';

void main() {
  final tState = AreasState(
    status: AreasStatus.initial,
    areas: BuiltSet(),
    hasError: false,
    nextPage: 1,
  );

  group('initial', () {
    test('initial state supports value comparison', () {
      expect(
          AreasState(
            status: AreasStatus.loading,
            areas: BuiltSet(),
            hasError: false,
            nextPage: 1,
          ),
          AreasState(
            status: AreasStatus.loading,
            areas: BuiltSet(),
            hasError: false,
            nextPage: 1,
          ));
      expect(
        AreasState(
          status: AreasStatus.loaded,
          areas: BuiltSet(nodes),
          hasError: false,
          nextPage: 3,
        ),
        AreasState(
          status: AreasStatus.loaded,
          areas: BuiltSet(nodes),
          hasError: false,
          nextPage: 3,
        ),
      );
    });
  });

  test('copy with', () {
    expect(
      tState.copyWith(hasError: true),
      AreasState(
        status: AreasStatus.initial,
        areas: BuiltSet(),
        hasError: true,
        nextPage: 1,
      ),
    );
    expect(
      tState.copyWith(
        status: AreasStatus.loaded,
        areas: BuiltSet(nodes),
        hasError: false,
        nextPage: 2,
      ),
      AreasState(
        status: AreasStatus.loaded,
        areas: BuiltSet(nodes),
        hasError: false,
        nextPage: 2,
      ),
    );
  });
}
