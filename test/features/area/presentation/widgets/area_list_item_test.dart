import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:wikiclimb_flutter_frontend/features/area/presentation/widgets/area_list_item.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/node.dart';

import '../../../../fixtures/area/area_nodes.dart';

void main() {
  testWidgets(
    'Test displaying list of screens',
    (tester) async {
      Node tArea = areaNodes.first;
      await mockNetworkImagesFor(
        () => tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AreaListItem(
                area: tArea,
              ),
            ),
          ),
        ),
      );
      expect(find.text(tArea.name), findsOneWidget);
      expect(find.text(tArea.description!), findsOneWidget);
      expect(find.text(tArea.breadcrumbs![1]), findsOneWidget);
      await tester.tap(find.byType(InkWell).first);
      await mockNetworkImagesFor(() => tester.pumpAndSettle());
      expect(find.text('Not implemented yet'), findsOneWidget);
    },
  );
}
