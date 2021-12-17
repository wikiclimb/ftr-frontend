// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:built_collection/built_collection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wikiclimb_flutter_frontend/core/collections/page.dart';
import 'package:wikiclimb_flutter_frontend/core/error/failure.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/node.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/node_fetch_params.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/usecases/fetch_all_nodes.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/bloc/node_list/node_list_bloc.dart';

import '../../../../../fixtures/area/area_pages.dart';
import '../../../../../fixtures/node/node_pages.dart';
import '../../../../../fixtures/node/nodes.dart';

class MockUsecase extends Mock implements FetchAllNodes {}

void main() {
  late FetchAllNodes mockUsecase;
  final tParams = NodeFetchParams((p) => p
    ..page = 1
    ..perPage = 20);

  setUp(() {
    mockUsecase = MockUsecase();
    when(() => mockUsecase.subscribe).thenAnswer((_) => Stream.empty());
  });

  test('initial state', () {
    expect(
        NodeListBloc(usecase: mockUsecase).state,
        NodeListState(
          status: NodeListStatus.initial,
          nodes: BuiltSet(),
          hasError: false,
          nextPage: 1,
        ));
    verify(() => mockUsecase.fetchPage(params: tParams)).called(1);
  });

  group('more data requested', () {
    final Page<Node> tPage = nodePages.first;
    final expected = tParams.rebuild((p) => p..parentId = 123);

    blocTest<NodeListBloc, NodeListState>(
      'data requests are forwarded with no parameters on first fetch',
      build: () => NodeListBloc(usecase: mockUsecase),
      act: (bloc) => bloc.add(NextPageRequested()),
      verify: (_) {
        verify(() => mockUsecase.fetchPage(params: tParams)).called(1);
      },
    );

    blocTest<NodeListBloc, NodeListState>(
      'data requests are forwarded with parent parameter',
      setUp: () => when(() => mockUsecase.subscribe).thenAnswer(
        (_) => Stream.value(Right(tPage)),
      ),
      seed: () => NodeListState(
        status: NodeListStatus.initial,
        nodes: BuiltSet(),
        hasError: false,
        nextPage: 1,
      ),
      build: () => NodeListBloc(usecase: mockUsecase, parentNode: nodes.first),
      act: (bloc) => bloc.add(NextPageRequested()),
      // Wait for the throttling
      wait: Duration(seconds: 1),
      expect: () => <NodeListState>[
        NodeListState(
          status: NodeListStatus.loaded,
          nodes: BuiltSet([nodes.first]),
          hasError: false,
          nextPage: 2,
        )
      ],
      verify: (_) {
        verify(
          () => mockUsecase.fetchPage(params: expected),
        ).called(1);
        verify(
          () => mockUsecase.fetchPage(
              params: expected.rebuild((p0) => p0..page = 2)),
        ).called(1);
      },
    );
  });

  group('response received', () {
    final Page<Node> tPage = areaPages.first;
    blocTest<NodeListBloc, NodeListState>(
      'successful data received',
      setUp: () => when(() => mockUsecase.subscribe).thenAnswer(
        (_) => Stream.value(Right(tPage)),
      ),
      build: () => NodeListBloc(usecase: mockUsecase),
      expect: () => <NodeListState>[
        NodeListState(
          status: NodeListStatus.loaded,
          nodes: tPage.items.toBuiltSet(),
          hasError: false,
          nextPage: 2,
        )
      ],
    );

    blocTest<NodeListBloc, NodeListState>(
      'error data received',
      setUp: () => when(() => mockUsecase.subscribe).thenAnswer(
        (_) => Stream.value(Left(NetworkFailure())),
      ),
      build: () => NodeListBloc(usecase: mockUsecase),
      expect: () => <NodeListState>[
        NodeListState(
          status: NodeListStatus.loaded,
          nodes: BuiltSet(),
          hasError: true,
          nextPage: 1,
        )
      ],
    );
  });

  group('search', () {
    const tQuery = 'hello';
    final Page<Node> tPage = areaPages.first;
    final tState = NodeListState(
      status: NodeListStatus.loading,
      nodes: BuiltSet(),
      hasError: false,
      nextPage: 1,
      query: tQuery,
    );
    final tState1 = tState.copyWith(
      status: NodeListStatus.loaded,
      nodes: tPage.items.toBuiltSet(),
      hasError: false,
      nextPage: 2,
    );

    blocTest<NodeListBloc, NodeListState>(
      'successful data received',
      setUp: () => when(() => mockUsecase.subscribe).thenAnswer(
        (_) => Stream.value(Right(tPage)),
      ),
      seed: () => tState,
      build: () => NodeListBloc(usecase: mockUsecase),
      act: (bloc) => bloc.add(SearchQueryUpdated(query: tQuery)),
      wait: Duration(milliseconds: 600),
      expect: () => <NodeListState>[tState1],
      verify: (_) =>
          verify(() => mockUsecase.fetchPage(params: tParams)).called(1),
    );
  });
}
