import 'package:bloc_test/bloc_test.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/image/presentation/bloc/list/image_list_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/inputs/inputs.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/node.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/bloc/node_edit/node_edit_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/screens/node_details_screen.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/widgets/map/node_popup.dart';

import '../../../../../fixtures/node/nodes.dart';

class MockAuthenticationBloc
    extends MockBloc<AuthenticationEvent, AuthenticationState>
    implements AuthenticationBloc {}

class MockNodeEditBloc extends MockBloc<NodeEditEvent, NodeEditState>
    implements NodeEditBloc {}

class MockImageListBloc extends MockBloc<ImageListEvent, ImageListState>
    implements ImageListBloc {}

extension on WidgetTester {
  Future<void> pumpIt({
    required Node node,
    required AuthenticationBloc mockAuthBloc,
  }) {
    return pumpWidget(
      BlocProvider<AuthenticationBloc>(
        create: (_) => mockAuthBloc,
        child: MaterialApp(
          home: Scaffold(
            body: NodePopup(node),
          ),
        ),
      ),
    );
  }
}

void main() {
  final node = nodes.first;
  late final AuthenticationBloc mockAuthBloc;
  late NodeEditBloc mockNodeEditBloc;
  late final ImageListBloc mockImageListBloc;

  setUpAll(() async {
    mockAuthBloc = MockAuthenticationBloc();
    when(() => mockAuthBloc.state).thenReturn(AuthenticationUnauthenticated());
    mockImageListBloc = MockImageListBloc();
    mockNodeEditBloc = MockNodeEditBloc();
    when(() => mockImageListBloc.state).thenAnswer(
      (_) => ImageListState(
        // Do not use initial state. It leads to the image list displaying a
        // [CircularProgressIndicator] that makes pumpAndSettle time out.
        status: ImageListStatus.loaded,
        images: BuiltSet(),
        hasError: false,
        nextPage: 1,
      ),
    );
    GetIt.I.registerLazySingleton<ImageListBloc>(() => mockImageListBloc);
    when(() => mockNodeEditBloc.state)
        .thenAnswer((_) => _getInitialState(nodes.first));
    GetIt.I.registerFactoryParam<NodeEditBloc, Node, void>(
        (node, _) => mockNodeEditBloc);
  });

  testWidgets(
    'creates the widget',
    (WidgetTester tester) async {
      await tester.pumpIt(node: node, mockAuthBloc: mockAuthBloc);
      expect(find.byType(NodePopup), findsOneWidget);
      expect(find.text(node.name), findsOneWidget);
    },
  );

  testWidgets(
    'navigates on tap',
    (WidgetTester tester) async {
      await tester.pumpIt(node: node, mockAuthBloc: mockAuthBloc);
      final finder = find.byType(NodePopup);
      expect(finder, findsOneWidget);
      await tester.tap(finder);
      await tester.pumpAndSettle();
      expect(find.byType(NodeDetailsScreen), findsOneWidget);
    },
  );
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
