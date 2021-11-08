import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wikiclimb_flutter_frontend/core/widgets/form/decorated_icon_input.dart';

const String hintText = 'test hint text';
const IconData prefixIcon = Icons.ac_unit;

void main() {
  testWidgets(
    'Test creating a decorated icon input',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DecoratedIconInput(
              key: const ValueKey('test-decorated-input'),
              hintText: hintText,
              prefixIcon: prefixIcon,
              fillColor: getColor(),
            ),
          ),
        ),
      );
      expect(find.byIcon(prefixIcon), findsOneWidget);
      // await tester.pumpAndSettle();
      expect(find.byType(DecoratedIconInput), findsOneWidget);
      expect(
          (tester.firstWidget(find.byType(DecoratedIconInput))
                  as DecoratedIconInput)
              .fillColor,
          getColor());
    },
  );

  testWidgets(
    'Decorated icon input default color',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DecoratedIconInput(
              hintText: hintText,
              prefixIcon: prefixIcon,
              key: ValueKey('test-decorated-input'),
            ),
          ),
        ),
      );
      expect(
          (tester.firstWidget(find.byType(DecoratedIconInput))
                  as DecoratedIconInput)
              .fillColor,
          Colors.white);
    },
  );
}

Color getColor() {
  return Colors.white;
}
