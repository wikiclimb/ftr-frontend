import 'package:flutter_test/flutter_test.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/bloc/node_list/node_list_bloc.dart';

import '../../../../../fixtures/node/node_pages.dart';

void main() {
  test('equality', () {
    final tNode = nodePages.first;
    expect(PageAdded(tNode), PageAdded(tNode));
    expect(FailureResponse().props, []);
  });
}
