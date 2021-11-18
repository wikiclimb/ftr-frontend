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
    verify(() => mockUsecase.fetchPage()).called(1);
  });

  group('more data requested', () {
    blocTest<AreasBloc, AreasState>(
      'data requests are forwarded with no parameters on first fetch',
      build: () => AreasBloc(usecase: mockUsecase),
      act: (bloc) => bloc.add(NextPageRequested()),
      verify: (_) => {verify(() => mockUsecase.fetchPage()).called(1)},
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
}
