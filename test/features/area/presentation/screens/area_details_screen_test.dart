// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'package:wikiclimb_flutter_frontend/core/widgets/decoration/photo_sliver_app_bar.dart';
import 'package:wikiclimb_flutter_frontend/features/area/presentation/screens/area_details_screen.dart';
import 'package:wikiclimb_flutter_frontend/features/area/presentation/widgets/area_details_list.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/node.dart';

import '../../../../fixtures/area/area_nodes.dart';

extension on WidgetTester {
  Future<void> pumpDetailsScreen(Node area) {
    return pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AreaDetailsScreen(area: area),
        ),
      ),
    );
  }
}

main() {
  testWidgets('screen renders', (tester) async {
    await mockNetworkImagesFor(
      () => tester.pumpDetailsScreen(areaNodes.first),
    );
    expect(find.byType(AreaDetailsScreen), findsOneWidget);
  });

  testWidgets('app bar renders using parameter data', (tester) async {
    await mockNetworkImagesFor(
      () => tester.pumpDetailsScreen(areaNodes.elementAt(5)),
    );
    expect(find.byType(PhotoSliverAppBar), findsOneWidget);
    expect(find.byType(AreaDetailsList), findsOneWidget);
    expect(find.byIcon(Icons.star), findsNWidgets(3));
    expect(find.byIcon(Icons.star_half), findsNothing);
  });
}
