import 'package:flutter_test/flutter_test.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/node.dart';

void main() {
  test('props returns id', () {
    const tNode = Node(
      id: 1243,
      type: 1,
      parentId: null,
      name: 'test-area',
      description: 'test-area-description',
      pointId: null,
      createdBy: 'test-user',
      createdAt: 1636899203,
      updatedBy: 'test-user',
      updatedAt: 1636899203,
    );
    expect(
      tNode.props,
      [
        1243,
        1,
        null,
        'test-area',
        'test-area-description',
        null,
        null,
        'test-user',
        1636899203,
        'test-user',
        1636899203,
      ],
      reason: 'Equatable node props should only consider ID',
    );
  });

  test('authentication data equality comparison should work', () {
    const tNode1 = Node(
      id: 1243,
      type: 10,
      parentId: 4,
      name: 'test-area-2',
      description: 'test-area-description-2',
      pointId: null,
      createdBy: 'test-user-2',
      createdAt: 1636899103,
      updatedBy: 'test-user-2',
      updatedAt: 1636899103,
    );
    const tNode2 = Node(
      id: 1243,
      type: 10,
      parentId: 4,
      name: 'test-area-2',
      description: 'test-area-description-2',
      pointId: null,
      createdBy: 'test-user-2',
      createdAt: 1636899103,
      updatedBy: 'test-user-2',
      updatedAt: 1636899103,
    );
    expect(
      tNode1,
      tNode2,
      reason: 'models with same data should be considered equal',
    );
  });

  test('authentication data equality comparison should fail', () {
    const tNode1 = Node(
      type: 10,
      parentId: 4,
      name: 'test-area-2',
      description: 'test-area-description-2',
      pointId: null,
      createdBy: 'test-user-2',
      createdAt: 1636899103,
      updatedBy: 'test-user-2',
      updatedAt: 1636899103,
    );
    const tNode2 = Node(
      type: 10,
      parentId: 4,
      name: 'test-area',
      description: 'test-area-description-2',
      pointId: null,
      createdBy: 'test-user-2',
      createdAt: 1636899103,
      updatedBy: 'test-user-2',
      updatedAt: 1636899103,
    );
    expect(
      tNode1,
      isNot(equals(tNode2)),
      reason: 'models with different data should not be considered equal',
    );
  });
}
