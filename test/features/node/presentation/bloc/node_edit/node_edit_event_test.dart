// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/bloc/node_edit/node_edit_bloc.dart';

import '../../../../../fixtures/node/nodes.dart';

void main() {
  test('supports value comparisons', () {
    final tNode = nodes.first;
    expect(NodeEditInitialize(tNode).props, [tNode]);
    expect(NodeEditInitialize(tNode), NodeEditInitialize(tNode));
    expect(
      NodeEditInitialize(tNode),
      isNot(
        equals(
          NodeEditInitialize(tNode.rebuild((p0) => p0..name = 'new-name')),
        ),
      ),
    );
  });

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
}
