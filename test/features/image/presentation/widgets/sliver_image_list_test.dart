// ignore_for_file: prefer_const_constructors

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:wikiclimb_flutter_frontend/features/image/presentation/screens/add_node_image_screen.dart';
import 'package:wikiclimb_flutter_frontend/features/image/presentation/widgets/sliver_image_list.dart';

import '../../../../fixtures/image/images.dart';
import '../../../../fixtures/node/nodes.dart';

extension on WidgetTester {
  Future<void> pumpIt() {
    return mockNetworkImagesFor(
      () => pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverImageList(BuiltSet(images), node: nodes.first),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  group('initialization', () {
    testWidgets('widget renders', (tester) async {
      await tester.pumpIt();
      expect(find.byType(SliverImageList), findsOneWidget);
    });

    testWidgets('should render one child', (tester) async {
      await tester.pumpIt();
      expect(
        find.byType(SliverImageListItem),
        findsOneWidget,
      );
    });
  });

  group('navigation', () {
    testWidgets('to add node image screen', (tester) async {
      await tester.pumpIt();
      final finder = find.byKey(
        Key('sliverImageList_addNodeImages_elevatedButton'),
      );
      expect(finder, findsOneWidget);
      await tester.tap(finder);
      await tester.pumpAndSettle();
      expect(find.byType(AddNodeImageScreen), findsOneWidget);
    });
  });
}
