import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wikiclimb_flutter_frontend/features/image/presentation/widgets/node_sliver_image_list.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/node.dart';

import '../../../../fixtures/node/nodes.dart';

extension on WidgetTester {
  Future<void> pumpIt(Node node) {
    return pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomScrollView(
            slivers: [
              NodeSliverImageList(node),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  testWidgets('widget renders', (tester) async {
    await tester.pumpIt(nodes.first);
    expect(find.byType(NodeSliverImageList), findsOneWidget);
  });
}
