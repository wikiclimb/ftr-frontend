import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:wikiclimb_flutter_frontend/features/image/presentation/widgets/sliver_image_list.dart';

import '../../../../fixtures/image/images.dart';

extension on WidgetTester {
  Future<void> pumpIt() {
    return mockNetworkImagesFor(
      () => pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverImageList(BuiltSet(images)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
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
}
