import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/widgets/node_breadcrumbs.dart';

import '../../../../fixtures/area/area_nodes.dart';

void main() {
  testWidgets('node breadcrumbs render', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NodeBreadcrumbs(areaNodes.first),
        ),
      ),
    );
    expect(find.byType(NodeBreadcrumbs), findsOneWidget);
  });
}
