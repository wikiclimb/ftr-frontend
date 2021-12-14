// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:built_collection/built_collection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wikiclimb_flutter_frontend/core/collections/page.dart';
import 'package:wikiclimb_flutter_frontend/core/error/failure.dart';
import 'package:wikiclimb_flutter_frontend/features/area/domain/usecases/fetch_all.dart';
import 'package:wikiclimb_flutter_frontend/features/area/presentation/bloc/list/areas_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/node.dart';

import '../../../../../fixtures/area/area_pages.dart';
import '../../../../../fixtures/node/node_pages.dart';
import '../../../../../fixtures/node/nodes.dart';

class MockUsecase extends Mock implements FetchAllAreas {}

void main() {
  late FetchAllAreas mockUsecase;

  setUp(() {
    mockUsecase = MockUsecase();
    when(() => mockUsecase.subscribe).thenAnswer((_) => Stream.empty());
  });

  test('initial state', () {
    expect(
        AreasBloc(usecase: mockUsecase).state,
        AreasState(
          status: AreasStatus.initial,
          areas: BuiltSet(),
          hasError: false,
          nextPage: 1,
        ));
    verify(() => mockUsecase.fetchPage(params: {'page': '1'})).called(1);
  });

  group('more data requested', () {
    final Page<Node> tPage = nodePages.first;

    blocTest<AreasBloc, AreasState>(
      'data requests are forwarded with no parameters on first fetch',
      build: () => AreasBloc(usecase: mockUsecase),
      act: (bloc) => bloc.add(NextPageRequested()),
      verify: (_) {
        verify(() => mockUsecase.fetchPage(params: {'page': '1'})).called(1);
      },
    );

    blocTest<AreasBloc, AreasState>(
      'data requests are forwarded with parent parameter',
      setUp: () => when(() => mockUsecase.subscribe).thenAnswer(
        (_) => Stream.value(Right(tPage)),
      ),
      seed: () => AreasState(
        status: AreasStatus.initial,
        areas: BuiltSet(),
        hasError: false,
        nextPage: 1,
      ),
      build: () => AreasBloc(usecase: mockUsecase, parentNode: nodes.first),
      act: (bloc) => bloc.add(NextPageRequested()),
      // Wait for the throttling
      wait: Duration(seconds: 1),
      expect: () => <AreasState>[
        AreasState(
          status: AreasStatus.loaded,
          areas: BuiltSet([nodes.first]),
          hasError: false,
          nextPage: 2,
        )
      ],
      verify: (_) {
        verify(
          () => mockUsecase.fetchPage(
            params: {'page': '1', 'parent-id': '123'},
          ),
        ).called(1);
        verify(
          () => mockUsecase.fetchPage(
            params: {
              'page': '2',
              'parent-id': '123',
            },
          ),
        ).called(1);
      },
    );
  });

  group('response received', () {
    final Page<Node> tPage = areaPages.first;
    blocTest<AreasBloc, AreasState>(
      'successful data received',
      setUp: () => when(() => mockUsecase.subscribe).thenAnswer(
        (_) => Stream.value(Right(tPage)),
      ),
      build: () => AreasBloc(usecase: mockUsecase),
      expect: () => <AreasState>[
        AreasState(
          status: AreasStatus.loaded,
          areas: tPage.items.toBuiltSet(),
          hasError: false,
          nextPage: 2,
        )
      ],
    );

    blocTest<AreasBloc, AreasState>(
      'error data received',
      setUp: () => when(() => mockUsecase.subscribe).thenAnswer(
        (_) => Stream.value(Left(NetworkFailure())),
      ),
      build: () => AreasBloc(usecase: mockUsecase),
      expect: () => <AreasState>[
        AreasState(
          status: AreasStatus.loaded,
          areas: BuiltSet(),
          hasError: true,
          nextPage: 1,
        )
      ],
    );
  });

  group('search', () {
    const tQuery = 'hello';
    final Page<Node> tPage = areaPages.first;
    final tState = AreasState(
      status: AreasStatus.loading,
      areas: BuiltSet(),
      hasError: false,
      nextPage: 1,
      query: tQuery,
    );
    final tState1 = tState.copyWith(
      status: AreasStatus.loaded,
      areas: tPage.items.toBuiltSet(),
      hasError: false,
      nextPage: 2,
    );

    blocTest<AreasBloc, AreasState>(
      'successful data received',
      setUp: () => when(() => mockUsecase.subscribe).thenAnswer(
        (_) => Stream.value(Right(tPage)),
      ),
      seed: () => tState,
      build: () => AreasBloc(usecase: mockUsecase),
      act: (bloc) => bloc.add(SearchQueryUpdated(query: tQuery)),
      wait: Duration(milliseconds: 600),
      expect: () => <AreasState>[tState1],
      verify: (_) => verify(
              () => mockUsecase.fetchPage(params: {'page': '1', 'q': tQuery}))
          .called(1),
    );
  });
}
