// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wikiclimb_flutter_frontend/features/area/presentation/screens/add_area_screen.dart';

void main() {
  testWidgets(
    'widget is created',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddAreaScreen(),
          ),
        ),
      );
      expect(find.byType(AddAreaScreen), findsOneWidget);
    },
  );
}
