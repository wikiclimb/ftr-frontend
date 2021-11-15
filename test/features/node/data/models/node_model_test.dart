import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:wikiclimb_flutter_frontend/features/node/data/models/node_model.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/node.dart';

import '../../../../fixtures/area/area_node_models.dart';
import '../../../../fixtures/fixture_reader.dart';
import '../../../../fixtures/node/node_models.dart';
import '../../../../fixtures/node/nodes.dart';

void main() {
  group('from json', () {
    test('should return a valid model', () async {
      final result = NodeModel.fromJson(fixture('area/single.json'));
      expect(result, isA<NodeModel>());
      expect(result?.breadcrumbs, ['One', 'Two', 'Three']);
      expect(result?.id, 2);
    });
  });

  group('to json', () {
    test('should return valid json', () {
      final NodeModel result = areaNodeModels.elementAt(2);
      final jsonString = result.toJson();
      final json = jsonDecode(jsonString);
      const expectedJsonMap = {
        'id': 123,
        'type': 1,
        'parent_id': 42,
        'name': 'test-area-3',
        'description': 'test-area-3-description',
        'cover_url': 'https://placeimg.com/1990',
        'rating': 4.9,
        'breadcrumbs': ['One', 'Three'],
        'created_by': 'test-user-2',
        'point_id': 7,
        'created_at': 1636879203,
        'updated_by': 'test-user-2',
        'updated_at': 1636899403
      };
      expect(json, expectedJsonMap);
    });
  });

  group('to json and back to dart', () {
    test('model converted to json and back is equal', () {
      final NodeModel nodeModel = areaNodeModels.elementAt(1);
      expect(
        NodeModel.fromJson(nodeModel.toJson()),
        nodeModel,
        reason: 'model obtained from the conversion should be equal original',
      );
    });
  });

  group('to node', () {
    test('convert to node', () {
      final Node expected = nodes.elementAt(0);
      final actual = nodeModels.elementAt(0);
      expect(
        actual.toNode(),
        expected,
        reason: 'conversion to [Node] should work',
      );
    });
  });

  group('built value methods', () {
    test('to string', () {
      expect(
        areaNodeModels.elementAt(1).toString(),
        areaNodeModels.elementAt(1).toString(),
      );
    });

    test('hash code', () {
      expect(
        areaNodeModels.elementAt(1).hashCode,
        areaNodeModels.elementAt(1).hashCode,
      );
    });

    test('rebuild', () {
      final tNodeModel = areaNodeModels.elementAt(0).rebuild((n) => n
        ..id = 2
        ..parentId = 42
        ..coverUrl = 'https://placeimg.com/1990');
      expect(tNodeModel.id, 2);
      expect(tNodeModel.parentId, 42);
      expect(tNodeModel.coverUrl, 'https://placeimg.com/1990');
      expect(tNodeModel.rating, 4.9);
    });
  });
}
