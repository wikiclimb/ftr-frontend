// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/inputs/inputs.dart';

import 'package:wikiclimb_flutter_frontend/features/node/presentation/bloc/node_edit/node_edit_bloc.dart';

void main() {
  test('initial equality', () {
    expect(NodeEditState(), NodeEditState());
  });

  group('copy with', () {
    final tNodeEditState = NodeEditState();
    final tLatitude = NodeLatitude.dirty('82.31');
    final tLongitude = NodeLongitude.dirty('-134.002');
    late NodeEditState tEdited;
    late NodeEditState tEdited2;
    setUp(() {
      tEdited = tNodeEditState.copyWith(
        status: FormzStatus.submissionFailure,
        type: 22,
      );
      tEdited2 = tNodeEditState.copyWith(
        status: FormzStatus.valid,
        type: 3,
        latitude: tLatitude,
        longitude: tLongitude,
      );
    });

    test('updates the values', () {
      expect(tEdited.type, 22);
      expect(tEdited.status, FormzStatus.submissionFailure);
      expect(tEdited2.latitude, tLatitude);
      expect(tEdited2.longitude, tLongitude);
    });
  });
}
