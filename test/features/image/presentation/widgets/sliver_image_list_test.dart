// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/entities/authentication_data.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/image/presentation/screens/add_node_image_screen.dart';
import 'package:wikiclimb_flutter_frontend/features/image/presentation/widgets/sliver_image_list.dart';
import 'package:wikiclimb_flutter_frontend/features/image/presentation/widgets/sliver_image_list_item.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/bloc/add_node_images/add_node_images_bloc.dart';

import '../../../../fixtures/image/images.dart';
import '../../../../fixtures/node/nodes.dart';

class MockAuthenticationBloc
    extends MockBloc<AuthenticationEvent, AuthenticationState>
    implements AuthenticationBloc {}

class MockAddNodeImagesBloc
    extends MockBloc<AddNodeImagesEvent, AddNodeImagesState>
    implements AddNodeImagesBloc {}

extension on WidgetTester {
  Future<void> pumpIt(AuthenticationBloc mockAuthenticationBloc) {
    return mockNetworkImagesFor(
      () => pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<AuthenticationBloc>(
                create: (context) => mockAuthenticationBloc,
                child: CustomScrollView(
                  slivers: [
                    SliverImageList(BuiltSet(images), node: nodes.first),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}

void main() {
  late AuthenticationBloc mockAuthenticationBloc;
  const tAuthData = AuthenticationData(
    token: 'token',
    id: 123,
    username: 'test-username',
  );
  late final AddNodeImagesBloc mockBloc;
  late final GetIt sl;

  setUpAll(() {
    mockAuthenticationBloc = MockAuthenticationBloc();
    when(() => mockAuthenticationBloc.state)
        .thenAnswer((_) => AuthenticationUnauthenticated());
    mockBloc = MockAddNodeImagesBloc();
    when(() => mockBloc.state).thenAnswer((_) => AddNodeImagesState());
    sl = GetIt.instance;
    sl.registerFactory<AddNodeImagesBloc>(() => mockBloc);
  });

  group('initialization', () {
    testWidgets('widget renders', (tester) async {
      await tester.pumpIt(mockAuthenticationBloc);
      expect(find.byType(SliverImageList), findsOneWidget);
    });

    testWidgets('should render one child', (tester) async {
      await tester.pumpIt(mockAuthenticationBloc);
      expect(
        find.byType(SliverImageListItem),
        findsOneWidget,
      );
    });
  });

  group('navigation', () {
    testWidgets('to add node image screen', (tester) async {
      when(() => mockAuthenticationBloc.state)
          .thenAnswer((_) => AuthenticationAuthenticated(tAuthData));
      await tester.pumpIt(mockAuthenticationBloc);
      final finder = find.byKey(
        Key('sliverImageList_addNodeImages_elevatedButton'),
      );
      expect(finder, findsOneWidget);
      await tester.tap(finder);
      await tester.pumpAndSettle();
      expect(find.byType(AddNodeImageScreen), findsOneWidget);
    });
  });
}
