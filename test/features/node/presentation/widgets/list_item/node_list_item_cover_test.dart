import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/widgets/list_item/node_list_item_cover.dart';

import '../../../../../fixtures/node/nodes.dart';

main() {
  testWidgets('the widget creates', (tester) async {
    await mockNetworkImagesFor(
      () => tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NodeListItemCover(nodes.first),
          ),
        ),
      ),
    );
    expect(find.byType(NodeListItemCover), findsOneWidget);
  });

  // TODO: Add a test for image error builder, that requires mocking the client
  // to return an error instead of always success. There is an example here:
  // https://github.com/flutter/flutter/blob/master/dev/manual_tests/test/mock_image_http.dart
}
