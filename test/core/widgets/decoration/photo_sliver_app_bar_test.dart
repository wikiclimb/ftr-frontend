// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'package:wikiclimb_flutter_frontend/core/widgets/decoration/photo_sliver_app_bar.dart';

void main() {
  testWidgets('creates widget', (tester) async {
    await mockNetworkImagesFor(
      () => tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                PhotoSliverAppBar(
                  title: 'app bar',
                  imageUrl: 'http://placeimg.com/nature',
                ),
              ],
            ),
          ),
        ),
      ),
    );
    expect(find.byType(PhotoSliverAppBar), findsOneWidget);
  });
}
