// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/entities/authentication_data.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/image/presentation/bloc/list/image_list_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/image/presentation/widgets/node_sliver_image_list.dart';
import 'package:wikiclimb_flutter_frontend/features/image/presentation/widgets/sliver_image_list.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/node.dart';

import '../../../../fixtures/image/images.dart';
import '../../../../fixtures/node/nodes.dart';

class MockAuthenticationBloc
    extends MockBloc<AuthenticationEvent, AuthenticationState>
    implements AuthenticationBloc {}

class MockImageListBloc extends MockBloc<ImageListEvent, ImageListState>
    implements ImageListBloc {}

extension on WidgetTester {
  Future<void> pumpIt(
    Node node,
    ImageListBloc mockImageListBloc,
    AuthenticationBloc mockAuthenticationBloc,
  ) {
    return pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomScrollView(
            slivers: [
              MultiBlocProvider(
                providers: [
                  BlocProvider<ImageListBloc>(
                      create: (context) => mockImageListBloc),
                  BlocProvider<AuthenticationBloc>(
                      create: (context) => mockAuthenticationBloc),
                ],
                child: NodeSliverImageList(node),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  late final AuthenticationBloc mockAuthenticationBloc;
  late final ImageListBloc mockImageListBloc;
  final tInitialState = ImageListState(
    status: ImageListStatus.initial,
    images: BuiltSet(),
    hasError: false,
    nextPage: 1,
  );

  setUpAll(() {
    mockAuthenticationBloc = MockAuthenticationBloc();
    mockImageListBloc = MockImageListBloc();
  });

  testWidgets('widget renders', (tester) async {
    when(() => mockImageListBloc.state).thenAnswer(
      (_) => tInitialState,
    );
    await tester.pumpIt(nodes.first, mockImageListBloc, mockAuthenticationBloc);
    expect(find.byType(NodeSliverImageList), findsOneWidget);
  });

  group('loading', () {
    final tState = tInitialState.copyWith(status: ImageListStatus.loading);

    testWidgets('displays the error notification', (tester) async {
      when(() => mockImageListBloc.state).thenAnswer(
        (_) => tState,
      );
      await tester.pumpIt(
          nodes.first, mockImageListBloc, mockAuthenticationBloc);
      expect(
        find.byType(NodeSliverImageListStatusNotification),
        findsOneWidget,
      );
      expect(
        find.byKey(Key('nodeSliverImageList_statusNotification_loading')),
        findsOneWidget,
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('error', () {
    final tState = tInitialState.copyWith(
      status: ImageListStatus.loaded,
      hasError: true,
    );

    testWidgets('displays the error notification', (tester) async {
      when(() => mockImageListBloc.state).thenAnswer(
        (_) => tState,
      );
      await tester.pumpIt(
          nodes.first, mockImageListBloc, mockAuthenticationBloc);
      expect(
          find.byType(NodeSliverImageListStatusNotification), findsOneWidget);
      expect(find.text('Error fetching images.'), findsOneWidget);
    });
  });

  group('success', () {
    final tState = tInitialState.copyWith(
      status: ImageListStatus.loaded,
      hasError: false,
      images: BuiltSet([images.first]),
    );
    const tAuthData = AuthenticationData(
      token: 'token',
      id: 123,
      username: 'test-username',
    );

    testWidgets('displays the images', (tester) async {
      when(() => mockImageListBloc.state).thenAnswer(
        (_) => tState,
      );
      when(() => mockAuthenticationBloc.state)
          .thenAnswer((_) => AuthenticationAuthenticated(tAuthData));
      await tester.pumpIt(
          nodes.first, mockImageListBloc, mockAuthenticationBloc);
      expect(find.byType(SliverImageList), findsOneWidget);
    });
  });
}
