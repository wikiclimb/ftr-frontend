// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'package:wikiclimb_flutter_frontend/core/widgets/decoration/photo_sliver_app_bar.dart';

extension on WidgetTester {
  Future<void> pumpSliverAppBar({
    String title = 'App Bar',
    String? url = 'http://placeimg.com/nature',
  }) {
    return mockNetworkImagesFor(
      () async => pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                PhotoSliverAppBar(
                  title: title,
                  imageUrl: url,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  group('creates widget', () {
    testWidgets('when url points to network resource', (tester) async {
      await tester.pumpSliverAppBar();
      expect(find.byType(PhotoSliverAppBar), findsOneWidget);
    });

    testWidgets('when url is null', (tester) async {
      await tester.pumpSliverAppBar(url: null);
      expect(
        find.byKey(Key('photoSliverAppBar_backgroundImage_nullPlaceholder')),
        findsOneWidget,
      );
    });
  });
  // TODO: Create a test that checks rendering when there is an error.
}
