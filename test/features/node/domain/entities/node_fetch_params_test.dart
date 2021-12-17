import 'package:flutter_test/flutter_test.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/node_fetch_params.dart';

void main() {
  final tParams = NodeFetchParams((p) => p
    ..page = 1
    ..perPage = 20);

  test('create', () {
    expect(tParams, isA<NodeFetchParams>());
  });

  test('value equality', () {
    expect(
        tParams,
        NodeFetchParams((p) => p
          ..page = 1
          ..perPage = 20));
  });

  test('to map', () {
    final rebuilt = tParams.rebuild((p) => p
      ..type = 2
      ..parentId = 3
      ..query = 'baboon');
    final tExpected = {
      'type': '2',
      'page': '1',
      'per-page': '20',
      'parent-id': '3',
      'q': 'baboon',
    };
    expect(rebuilt.toMap(), tExpected);
  });
}
