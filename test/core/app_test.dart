import 'package:flutter_test/flutter_test.dart';
import 'package:wikiclimb_flutter_frontend/core/app.dart';

void main() {
  testWidgets('Title displays', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    expect(find.text('WikiClimb'), findsOneWidget);
  });
}
