// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:wikiclimb_flutter_frontend/features/area/presentation/screens/area_details_screen.dart';
import 'package:wikiclimb_flutter_frontend/features/area/presentation/widgets/area_list_item.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/image/presentation/bloc/list/image_list_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/inputs/inputs.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/node.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/bloc/node_edit/node_edit_bloc.dart';

import '../../../../fixtures/area/area_nodes.dart';
import '../../../../fixtures/node/nodes.dart';

class MockAuthenticationBloc
    extends MockBloc<AuthenticationEvent, AuthenticationState>
    implements AuthenticationBloc {}

class MockNodeEditBloc extends MockBloc<NodeEditEvent, NodeEditState>
    implements NodeEditBloc {}

class MockImageListBloc extends MockBloc<ImageListEvent, ImageListState>
    implements ImageListBloc {}

void main() {
  late final AuthenticationBloc mockAuthBloc;
  late NodeEditBloc mockNodeEditBloc;
  late final ImageListBloc mockImageListBloc;

  setUpAll(() async {
    mockAuthBloc = MockAuthenticationBloc();
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
    'Test displaying list of screens',
    (tester) async {
      when(() => mockAuthBloc.state).thenAnswer(
        (_) => AuthenticationUnauthenticated(),
      );
      Node tArea = areaNodes.first;
      await mockNetworkImagesFor(
        () => tester.pumpWidget(
          BlocProvider<AuthenticationBloc>(
            create: (context) => mockAuthBloc,
            child: MaterialApp(
              home: Scaffold(
                body: AreaListItem(
                  area: tArea,
                ),
              ),
            ),
          ),
        ),
      );
      expect(find.text(tArea.name), findsOneWidget);
      expect(find.text(tArea.description!), findsOneWidget);
      expect(find.text(tArea.breadcrumbs![1]), findsOneWidget);
      await tester.tap(find.byType(InkWell).first);
      await mockNetworkImagesFor(() => tester.pumpAndSettle());
      expect(find.byType(AreaDetailsScreen), findsOneWidget);
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
