import 'package:built_collection/built_collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/node.dart';

void main() {
  test('authentication data equality comparison should work', () {
    final tNode1 = Node((n) => n
      ..id = 1234
      ..type = 1
      ..name = 'test-area-1'
      ..description = 'test-area-description'
      ..createdBy = 'test-user'
      ..createdAt = 1636899203
      ..updatedBy = 'test-user'
      ..updatedAt = 1636899203);

    final tNode2 = Node((n) => n
      ..id = 1234
      ..type = 1
      ..name = 'test-area-1'
      ..description = 'test-area-description'
      ..createdBy = 'test-user'
      ..createdAt = 1636899203
      ..updatedBy = 'test-user'
      ..updatedAt = 1636899203);

    expect(
      tNode1,
      tNode2,
      reason: 'models with same data should be considered equal',
    );

    expect(
      tNode1.hashCode,
      tNode2.hashCode,
      reason: 'equal models should have equal hash code',
    );

    expect(
      tNode1.toString(),
      tNode2.toString(),
      reason: 'equal models should have equal hash code',
    );
  });

  test('authentication data equality comparison should fail', () {
    final tNode1 = Node((n) => n
      ..id = 1234
      ..type = 1
      ..name = 'test-area-1'
      ..description = 'test-area-description'
      ..createdBy = 'test-user'
      ..createdAt = 1636899203
      ..updatedBy = 'test-user'
      ..updatedAt = 1636899203);
    final tNode2 = Node((n) => n
      ..id = 123
      ..type = 1
      ..name = 'test-area-1'
      ..description = 'test-area-description'
      ..createdBy = 'test-user'
      ..createdAt = 1636899203
      ..updatedBy = 'test-user'
      ..updatedAt = 1636899203);
    expect(
      tNode1,
      isNot(equals(tNode2)),
      reason: 'models with different data should not be considered equal',
    );
  });

  test('updating properties', () {
    final tNode = Node((n) => n
      ..id = 1234
      ..type = 1
      ..parentId = 10
      ..name = 'test-area-1'
      ..description = 'test-area-description'
      ..rating = 3.4
      ..breadcrumbs = BuiltList<String>(['One', 'Two']).toBuilder()
      ..pointId = 20
      ..coverUrl = 'https://coolpics/02210.jpg'
      ..createdBy = 'test-user'
      ..createdAt = 1636899203
      ..updatedBy = 'test-user'
      ..updatedAt = 1636899203);
    final updatedNode = tNode.rebuild((n) => n..parentId = 8);
    expect(updatedNode.id, 1234);
    expect(updatedNode.parentId, 8);
  });
}
