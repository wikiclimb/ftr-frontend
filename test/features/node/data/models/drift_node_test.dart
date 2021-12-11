import 'package:flutter_test/flutter_test.dart';
import 'package:wikiclimb_flutter_frontend/core/database/database.dart';

void main() {
  test('create row', () {
    final driftNode = DriftNode(
      nodeTypeId: 1,
      name: 'name',
      createdAt: 119,
      createdBy: 'createdBy',
    );
    expect(driftNode, isA<DriftNode>());
  });
}
