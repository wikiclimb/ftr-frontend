// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wikiclimb_flutter_frontend/features/area/presentation/widgets/area_details_list.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/node.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/widgets/node_breadcrumbs.dart';

import '../../../../fixtures/area/area_nodes.dart';

extension on WidgetTester {
  Future<void> pumpDetailsList(Node area) {
    return pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomScrollView(
            slivers: [
              AreaDetailsList(area: area),
            ],
          ),
        ),
      ),
    );
  }
}

main() {
  testWidgets('screen renders', (tester) async {
    await tester.pumpDetailsList(areaNodes.first);
    expect(find.byType(AreaDetailsList), findsOneWidget);
  });

  testWidgets('renders a list of slivers', (tester) async {
    await tester.pumpDetailsList(areaNodes.first);
    expect(find.byType(NodeBreadcrumbs), findsOneWidget);
  });

  testWidgets('breadcrumbs do not render when empty', (tester) async {
    await tester.pumpDetailsList(areaNodes.elementAt(6));
    expect(find.text('test-area-7'), findsOneWidget);
    expect(find.byType(NodeBreadcrumbs), findsNothing);
  });
}
