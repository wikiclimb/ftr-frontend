import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wikiclimb_flutter_frontend/features/image/presentation/screens/add_node_image_screen.dart';

import '../../../../fixtures/node/nodes.dart';

void main() {
  testWidgets('widget renders', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AddNodeImageScreen(nodes.elementAt(1)),
        ),
      ),
    );
    expect(find.byType(AddNodeImageScreen), findsOneWidget);
  });
}
