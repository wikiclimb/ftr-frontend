// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wikiclimb_flutter_frontend/core/widgets/decoration/star_rating_widget.dart';

extension on WidgetTester {
  Future<void> pumpStarWidget({
    required double rating,
    required ratingsCount,
    displayRatingDigits = true,
    displayRatingsCount = true,
  }) {
    return pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StarRatingWidget(
            rating: rating,
            ratingsCount: ratingsCount,
            displayRatingDigits: displayRatingDigits,
            displayRatingsCount: displayRatingsCount,
          ),
        ),
      ),
    );
  }
}

void main() {
  testWidgets('displays widget', (tester) async {
    await tester.pumpStarWidget(
      rating: 3.9,
      ratingsCount: 33441,
    );
    expect(find.byType(StarRatingWidget), findsOneWidget);
    expect(find.text('3.9'), findsOneWidget);
    expect(find.text('(33441)'), findsOneWidget);
  });

  testWidgets('displays full stars', (tester) async {
    await tester.pumpStarWidget(
      rating: 3.9,
      ratingsCount: 33441,
    );
    expect(find.byIcon(Icons.star), findsNWidgets(3));
  });

  testWidgets('displays half stars', (tester) async {
    await tester.pumpStarWidget(
      rating: 3.9,
      ratingsCount: 33441,
    );
    expect(find.byIcon(Icons.star_half), findsOneWidget);
  });

  testWidgets('does not display half stars', (tester) async {
    await tester.pumpStarWidget(
      rating: 3.49,
      ratingsCount: 33441,
    );
    expect(find.byIcon(Icons.star_half), findsNothing);
  });

  testWidgets('displays widget', (tester) async {
    await tester.pumpStarWidget(
      rating: 3.9,
      ratingsCount: 33441,
      displayRatingsCount: false,
    );
    expect(find.byType(StarRatingWidget), findsOneWidget);
    expect(find.text('3.9'), findsOneWidget);
    expect(find.text('(33441)'), findsNothing);
  });

  testWidgets('displays widget', (tester) async {
    await tester.pumpStarWidget(
      rating: 3.9,
      ratingsCount: 33441,
      displayRatingDigits: false,
    );
    expect(find.byType(StarRatingWidget), findsOneWidget);
    expect(find.text('3.9'), findsNothing);
    expect(find.text('(33441)'), findsOneWidget);
  });
}
