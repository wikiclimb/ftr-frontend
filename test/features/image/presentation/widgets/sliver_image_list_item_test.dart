// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:wikiclimb_flutter_frontend/features/image/domain/entities/image.dart'
    as wkc;
import 'package:wikiclimb_flutter_frontend/features/image/presentation/widgets/sliver_image_list_item.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/inputs/inputs.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/node.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/bloc/node_edit/node_edit_bloc.dart';

import '../../../../fixtures/image/images.dart';
import '../../../../fixtures/node/nodes.dart';

class MockNodeEditBloc extends MockBloc<NodeEditEvent, NodeEditState>
    implements NodeEditBloc {}

extension on WidgetTester {
  Future<void> pumpIt(NodeEditBloc mockBloc, wkc.Image image) {
    return pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (context) => mockBloc,
          child: Scaffold(
            body: SizedBox(
              height: 200,
              width: 200,
              child: SliverImageListItem(
                image: image,
                key: UniqueKey(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  late NodeEditBloc mockBloc;
  late final Node tNode;
  late final wkc.Image tImage;
  late final NodeEditState tState;

  setUpAll(() {
    tNode = nodes.first;
    tImage = images.first;
    tState = _getInitialState(tNode);
  });

  setUp(() {
    mockBloc = MockNodeEditBloc();
    when(() => mockBloc.state).thenAnswer((_) => tState);
  });

  group('initialization', () {
    testWidgets('widget renders', (tester) async {
      await tester.pumpIt(mockBloc, tImage);
      expect(find.byType(SliverImageListItem), findsOneWidget);
    });

    testWidgets('should render one child', (tester) async {
      await tester.pumpIt(mockBloc, tImage);
      expect(find.byType(Card), findsOneWidget);
    });
  });

  group('user long press', () {
    // Without the SizedBox the first test executed fails

    testWidgets('should show alert dialog', (tester) async {
      await mockNetworkImagesFor(() => tester.pumpIt(mockBloc, tImage));
      final finder = find.descendant(
        of: find.byType(Card),
        matching: find.byType(InkWell),
      );
      expect(finder, findsOneWidget);
      await tester.longPress(finder);
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Update cover'), findsOneWidget);
    });

    testWidgets('should push bloc event on OK press', (tester) async {
      await tester.pumpIt(mockBloc, tImage);
      final finder = find.descendant(
        of: find.byType(Card),
        matching: find.byType(InkWell),
      );
      expect(finder, findsOneWidget);
      await tester.longPress(finder);
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Update cover'), findsOneWidget);
      final okFinder = find.text('OK');
      expect(okFinder, findsOneWidget);
      await tester.tap(okFinder);
      verify(() => mockBloc.add(NodeCoverUpdateRequested(tImage.fileName)))
          .called(1);
    });

    testWidgets('should hide alert dialog if user cancels', (tester) async {
      await tester.pumpIt(mockBloc, tImage);
      final finder = find.descendant(
        of: find.byType(Card),
        matching: find.byType(InkWell),
      );
      expect(finder, findsOneWidget);
      await tester.pump(Duration(seconds: 3));
      await tester.longPress(finder);
      await tester.pump(Duration(seconds: 3));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Update cover'), findsOneWidget);
      final cancelFinder = find.text('Cancel');
      expect(cancelFinder, findsOneWidget);
      await tester.tap(cancelFinder);
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
      verifyNever(
        () => mockBloc.add(NodeCoverUpdateRequested(tImage.fileName)),
      );
    });
  });
}

NodeEditState _getInitialState(Node node) {
  return NodeEditState(
    node: node,
    type: node.type,
    name: NodeName.pure(node.name),
    description: NodeDescription.pure(node.description ?? ''),
    latitude: NodeLatitude.pure(node.lat?.toString() ?? ''),
    longitude: NodeLongitude.pure(node.lng?.toString() ?? ''),
  );
}
