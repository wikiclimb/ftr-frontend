// ignore_for_file: prefer_const_constructors
import 'package:built_collection/built_collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wikiclimb_flutter_frontend/features/area/presentation/bloc/list/areas_bloc.dart';

import '../../../../../fixtures/area/area_pages.dart';

void main() {
  group('AreaState', () {
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
          areas: BuiltSet([areaPages.first]),
          hasError: false,
          nextPage: 3,
        ),
        AreasState(
          status: AreasStatus.loaded,
          areas: BuiltSet([areaPages.first]),
          hasError: false,
          nextPage: 3,
        ),
      );
    });
  });
}
