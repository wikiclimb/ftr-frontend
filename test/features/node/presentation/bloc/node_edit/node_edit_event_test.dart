// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/bloc/node_edit/node_edit_bloc.dart';

void main() {
  group('node name changed', () {
    test('supports value comparisons', () {
      const name = 'test name';
      expect(NodeNameChanged(name), NodeNameChanged(name));
      expect(NodeNameChanged(name).props, [name]);
    });
  });

  group('node description changed', () {
    test('supports value comparisons', () {
      const description = 'test description';
      expect(
        NodeDescriptionChanged(description),
        NodeDescriptionChanged(description),
      );
      expect(NodeDescriptionChanged(description).props, [description]);
    });
  });

  group('node latitude changed', () {
    test('supports value comparisons', () {
      const latitude = '80.03';
      expect(
        NodeLatitudeChanged(latitude),
        NodeLatitudeChanged(latitude),
      );
      expect(NodeLatitudeChanged(latitude).props, [latitude]);
    });
  });

  group('node longitude changed', () {
    test('supports value comparisons', () {
      const longitude = '-170.03';
      expect(
        NodeLongitudeChanged(longitude),
        NodeLongitudeChanged(longitude),
      );
      expect(NodeLongitudeChanged(longitude).props, [longitude]);
    });
  });

  group('node submission requested', () {
    test('supports value comparisons', () {
      expect(NodeSubmissionRequested(), NodeSubmissionRequested());
    });
  });

  group('node cover update requested', () {
    const tName = 'file.jpg';
    test('supports value comparisons', () {
      expect(NodeCoverUpdateRequested(tName), NodeCoverUpdateRequested(tName));
      expect(NodeCoverUpdateRequested(tName).props, [tName]);
    });
  });
}
