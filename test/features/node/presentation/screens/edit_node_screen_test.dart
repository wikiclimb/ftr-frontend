import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wikiclimb_flutter_frontend/core/utils/locator.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/usecases/edit_node.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/bloc/node_edit/node_edit_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/screens/edit_node_screen.dart';

import '../../../../fixtures/node/nodes.dart';

class MockEditNode extends Mock implements EditNode {}

extension on WidgetTester {
  Future<void> pumpEditNodeScreen(NodeEditBloc mockBloc) {
    return pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider(
            create: (context) => mockBloc,
            child: const EditNodeScreen(),
          ),
        ),
      ),
    );
  }
}

class MockNodeEditBloc extends MockBloc<NodeEditEvent, NodeEditState>
    implements NodeEditBloc {}

class MockLocator extends Mock implements Locator {}

void main() {
  late NodeEditBloc mockBloc;
  final tState = NodeEditState(node: nodes.first);

  setUp(() {
    mockBloc = MockNodeEditBloc();
    when(() => mockBloc.state).thenReturn(tState);
  });

  testWidgets('widget renders', (WidgetTester tester) async {
    await tester.pumpEditNodeScreen(mockBloc);
    expect(find.byType(EditNodeScreen), findsOneWidget);
  });
}
