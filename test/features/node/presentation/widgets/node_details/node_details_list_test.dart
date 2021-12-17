// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/node.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/widgets/node_breadcrumbs.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/widgets/node_details/node_details_list.dart';

import '../../../../../fixtures/node/nodes.dart';

extension on WidgetTester {
  Future<void> pumpDetailsList(Node node) {
    return pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomScrollView(
            slivers: [
              NodeDetailsList(node),
            ],
          ),
        ),
      ),
    );
  }
}

main() {
  testWidgets('screen renders', (tester) async {
    await tester.pumpDetailsList(nodes.first);
    expect(find.byType(NodeDetailsList), findsOneWidget);
  });

  testWidgets('renders a list of slivers', (tester) async {
    await tester.pumpDetailsList(nodes.first);
    expect(find.byType(NodeBreadcrumbs), findsOneWidget);
  });

  testWidgets('breadcrumbs do not render when empty', (tester) async {
    await tester.pumpDetailsList(nodes.elementAt(1));
    expect(find.text('test-area-1'), findsOneWidget);
    expect(find.byType(NodeBreadcrumbs), findsNothing);
  });

  group('grade display', () {
    testWidgets('does not display for areas', (tester) async {
      await tester.pumpDetailsList(nodes.elementAt(1));
      expect(
        find.byKey(Key('nodeDetailsList_routeGrade_Text')),
        findsNothing,
      );
    });

    testWidgets('does display for routes', (tester) async {
      await tester.pumpDetailsList(nodes.elementAt(4));
      expect(find.text('test-node-4'), findsOneWidget);
      expect(
        find.byKey(Key('nodeDetailsList_routeGrade_Text')),
        findsOneWidget,
      );
    });
  });
}
