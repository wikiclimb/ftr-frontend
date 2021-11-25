// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:built_collection/built_collection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wikiclimb_flutter_frontend/core/collections/page.dart';
import 'package:wikiclimb_flutter_frontend/core/error/failure.dart';
import 'package:wikiclimb_flutter_frontend/features/image/domain/entities/image.dart';
import 'package:wikiclimb_flutter_frontend/features/image/domain/usecases/fetch_all_images.dart';
import 'package:wikiclimb_flutter_frontend/features/image/presentation/bloc/list/image_list_bloc.dart';

import '../../../../../fixtures/image/image_pages.dart';
import '../../../../../fixtures/node/nodes.dart';

class MockUseCase extends Mock implements FetchAllImages {}

void main() {
  late FetchAllImages mockUseCase;

  setUp(() {
    mockUseCase = MockUseCase();
    when(() => mockUseCase.subscribe).thenAnswer((_) => Stream.empty());
  });

  test('initial state', () {
    expect(
        ImageListBloc(usecase: mockUseCase).state,
        ImageListState(
          status: ImageListStatus.initial,
          images: BuiltSet(),
          hasError: false,
          nextPage: 1,
        ));
    verifyNever(() => mockUseCase.fetchPage());
  });

  group('initialization requested', () {
    final Page<Image> tPage = imagePages.first;
    final tNode = nodes.first;
    late Map<String, dynamic> expected;

    blocTest<ImageListBloc, ImageListState>(
      'with node',
      setUp: () {
        expected = {'page': '1', 'node-id': '123'};
        when(() => mockUseCase.subscribe).thenAnswer(
          (_) => Stream.value(Right(tPage)),
        );
      },
      build: () => ImageListBloc(usecase: mockUseCase),
      act: (bloc) => bloc.add(InitializationRequested(node: tNode)),
      expect: () => <ImageListState>[
        ImageListState(
          status: ImageListStatus.loading,
          images: BuiltSet(),
          hasError: false,
          nextPage: 1,
          node: tNode,
        ),
        ImageListState(
          status: ImageListStatus.loaded,
          images: tPage.items.toBuiltSet(),
          hasError: false,
          nextPage: 2,
          node: tNode,
        ),
      ],
      verify: (_) => {
        verify(
          () => mockUseCase.fetchPage(
            params: captureAny(
              named: 'params',
              that: equals(expected),
            ),
          ),
        ),
        // Had to use argument capture to match in previous version.
        // expect(
        //     verify(
        //       () => mockUseCase.fetchPage(
        //           params: captureAny(
        //         named: 'params', that: isA<Map<String, dynamic>>(),
        //         // that: equals(expected),
        //       )),
        //     ).captured,
        //     equals([expected])),
      },
    );

    blocTest<ImageListBloc, ImageListState>(
      'without node',
      setUp: () {
        expected = {'page': '1'};
        when(() => mockUseCase.subscribe).thenAnswer(
          (_) => Stream.value(Right(tPage)),
        );
      },
      build: () => ImageListBloc(usecase: mockUseCase),
      act: (bloc) => bloc.add(InitializationRequested()),
      expect: () => <ImageListState>[
        ImageListState(
          status: ImageListStatus.loading,
          images: BuiltSet(),
          hasError: false,
          nextPage: 1,
        ),
        ImageListState(
          status: ImageListStatus.loaded,
          images: tPage.items.toBuiltSet(),
          hasError: false,
          nextPage: 2,
        ),
      ],
      verify: (_) => {
        verify(
          () => mockUseCase.fetchPage(
            params: captureAny(
              named: 'params',
              that: equals(expected),
            ),
          ),
        ),
      },
    );
  });

  group('more data requested', () {
    blocTest<ImageListBloc, ImageListState>(
      'data requests are forwarded with no parameters on first fetch',
      build: () => ImageListBloc(usecase: mockUseCase),
      act: (bloc) => bloc.add(NextPageRequested()),
      verify: (_) => {
        verify(
          () => mockUseCase.fetchPage(
            params: any(named: 'params'),
          ),
        ).called(1)
      },
    );
  });

  group('response received', () {
    final Page<Image> tPage = imagePages.first;
    blocTest<ImageListBloc, ImageListState>(
      'successful data received',
      setUp: () => when(() => mockUseCase.subscribe).thenAnswer(
        (_) => Stream.value(Right(tPage)),
      ),
      build: () => ImageListBloc(usecase: mockUseCase),
      expect: () => <ImageListState>[
        ImageListState(
          status: ImageListStatus.loaded,
          images: tPage.items.toBuiltSet(),
          hasError: false,
          nextPage: 2,
        )
      ],
    );

    blocTest<ImageListBloc, ImageListState>(
      'error data received',
      setUp: () => when(() => mockUseCase.subscribe).thenAnswer(
        (_) => Stream.value(Left(NetworkFailure())),
      ),
      build: () => ImageListBloc(usecase: mockUseCase),
      expect: () => <ImageListState>[
        ImageListState(
          status: ImageListStatus.loaded,
          images: BuiltSet(),
          hasError: true,
          nextPage: 1,
        )
      ],
    );
  });
}
