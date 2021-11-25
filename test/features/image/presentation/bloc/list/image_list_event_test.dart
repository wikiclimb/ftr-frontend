// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:wikiclimb_flutter_frontend/features/image/presentation/bloc/list/image_list_bloc.dart';

import '../../../../../fixtures/image/image_pages.dart';
import '../../../../../fixtures/node/nodes.dart';

void main() {
  test('equality', () {
    final tPage = imagePages.first;
    expect(PageAdded(tPage), PageAdded(tPage));
    expect(FailureResponse().props, []);
  });

  group('initialization required', () {
    test('initialize event with node', () {
      final tEvent = InitializationRequested(node: nodes.first);
      expect(tEvent.props, [nodes.first]);
    });

    test('initialize event with null node', () {
      expect(InitializationRequested().props, []);
      expect(InitializationRequested(), InitializationRequested());
    });
  });
}
