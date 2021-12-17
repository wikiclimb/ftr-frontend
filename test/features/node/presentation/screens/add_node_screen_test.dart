// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wikiclimb_flutter_frontend/core/utils/locator.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/node.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/usecases/edit_node.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/bloc/node_edit/node_edit_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/screens/add_node_screen.dart';

class MockEditNode extends Mock implements EditNode {}

class MockLocator extends Mock implements Locator {}

void main() {
  late final GetIt sl;
  late final EditNode mockEditNode;
  late final Locator mockLocator;

  setUpAll(() async {
    sl = GetIt.instance;
    mockEditNode = MockEditNode();
    mockLocator = MockLocator();
    sl.registerFactoryParam<NodeEditBloc, Node, void>(
      (node, _) => NodeEditBloc(
        editNode: mockEditNode,
        locator: mockLocator,
        node: node,
      ),
    );
  });

  group('initial state', () {
    testWidgets(
      'widget is created',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AddNodeScreen(type: 1),
            ),
          ),
        );
        expect(find.byType(AddNodeScreen), findsOneWidget);
      },
    );

    testWidgets(
      'node edit form is created',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AddNodeScreen(type: 2),
            ),
          ),
        );
        expect(
          find.byKey(Key('addNodeScreen_nodeDetailsForm')),
          findsOneWidget,
        );
        // Wait for initial state to the piped through bloc
        await tester.pumpAndSettle();
        expect(
          find.text('Add Route'),
          findsOneWidget,
          reason: 'add area screen should pass a new area node',
        );
      },
    );
  });
}
