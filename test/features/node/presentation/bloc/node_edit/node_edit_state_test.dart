// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';

import 'package:wikiclimb_flutter_frontend/features/node/presentation/bloc/node_edit/node_edit_bloc.dart';

void main() {
  test('initial equality', () {
    expect(NodeEditState(), NodeEditState());
  });

  group('copy with', () {
    final tNodeEditState = NodeEditState();
    final edited = tNodeEditState.copyWith(
      status: FormzStatus.submissionFailure,
      type: 22,
    );
    test('updates the values', () {
      expect(edited.type, 22);
      expect(edited.status, FormzStatus.submissionFailure);
    });
  });
}
