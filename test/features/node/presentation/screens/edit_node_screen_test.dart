import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wikiclimb_flutter_frontend/core/utils/locator.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/usecases/edit_node.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/bloc/node_edit/node_edit_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/screens/edit_node_screen.dart';

import '../../../../fixtures/node/nodes.dart';

class MockEditNode extends Mock implements EditNode {}

extension on WidgetTester {
  Future<void> pumpEditNodeScreen() {
    return pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EditNodeScreen(nodes.first),
        ),
      ),
    );
  }
}

class MockLocator extends Mock implements Locator {}

void main() {
  setUpAll(() async {
    final sl = GetIt.instance;
    sl.registerLazySingleton<NodeEditBloc>(
      () => NodeEditBloc(
        editNode: MockEditNode(),
        locator: MockLocator(),
      ),
    );
  });
  testWidgets('widget renders', (WidgetTester tester) async {
    await tester.pumpEditNodeScreen();
    expect(find.byType(EditNodeScreen), findsOneWidget);
  });
}
