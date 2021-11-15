// import 'dart:convert';

// import 'package:flutter_test/flutter_test.dart';
// import 'package:wikiclimb_flutter_frontend/features/node/data/models/node_model.dart';
// import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/node.dart';

// import '../../../../fixtures/area/area_node_models.dart';
// import '../../../../fixtures/fixture_reader.dart';

// void main() {
//   test(
//     'NodeModel should extend Node',
//     () {
//       final tNodeModel = areaNodeModels.first;
//       expect(tNodeModel, isA<Node>());
//     },
//   );

//   group('from json', () {
//     test('should return a valid model', () async {
//       final Map<String, dynamic> jsonMap =
//           jsonDecode(fixture('area/single.json'));
//       final result = NodeModel.fromJson(jsonMap);
//       expect(result, isA<NodeModel>());
//       expect(result.breadcrumbs, ['One', 'Two', 'Three']);
//       expect(result.id, 2);
//     });
//   });

//   group('to json', () {
//     test('should return valid json', () {
//       final NodeModel result = areaNodeModels.elementAt(2);
//       final json = result.toJson();
//       const expectedJsonMap = {
//         'id': 1243,
//         'type': 1,
//         'parent_id': null,
//         'name': 'test-area-2',
//         'description': 'test-area-2-description',
//         'rating': 4.9,
//         'breadcrumbs': ['Two', 'Three'],
//         'point_id': null,
//         'cover_url': null,
//         'created_by': 'test-user-2',
//         'created_at': 1636899203,
//         'updated_by': 'test-user-2',
//         'updated_at': 1636899203
//       };
//       expect(json, expectedJsonMap);
//     });
//   });

//   group('to json and back to dart', () {
//     test('model converted to json and back is equal', () {
//       final NodeModel nodeModel = areaNodeModels.elementAt(1);
//       final jsonMap = nodeModel.toJson();
//       expect(jsonMap, isA<Map<String, dynamic>>());
//       final result = NodeModel.fromJson(jsonMap);
//       expect(
//         result,
//         nodeModel,
//         reason: 'model obtained from the conversion should be equal original',
//       );
//     });
//   });
// }
void main() {}
