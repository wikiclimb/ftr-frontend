import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:wikiclimb_flutter_frontend/core/error/failure.dart';
import 'package:wikiclimb_flutter_frontend/core/usecases/usecase.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/entities/authentication_data.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/usecases/fetch_cached.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/presentation/bloc/authentication_cubit.dart';

import 'authentication_cubit_test.mocks.dart';

@GenerateMocks([FetchCached])
void main() {
  late AuthenticationCubit cubit;
  late MockFetchCached usecase;

  setUpAll(() {
    usecase = MockFetchCached();
    cubit = AuthenticationCubit(fetchCachedUsecase: usecase);
  });

  group('success responses', () {
    const tAuthenticationData = AuthenticationData(
      token: 'test-token',
      id: 123,
    );

    test('should return data when found', () async {
      when(usecase(NoParams())).thenAnswer(
        (_) async => const Right(tAuthenticationData),
      );
      final expected = [
        AuthenticationLoading(),
        const AuthenticationSuccess(tAuthenticationData),
      ];
      expectLater(cubit.stream, emitsInOrder(expected));
      cubit.fetchCachedData();
      verify(usecase(NoParams())).called(1);
      verifyNoMoreInteractions(usecase);
    });
  });

  group('error responses', () {
    test('no cached data', () async {
      when(usecase(NoParams())).thenAnswer(
        (_) async => Left(AuthenticationFailure()),
      );
      final expected = [
        AuthenticationLoading(),
        AuthenticationError(),
      ];
      expectLater(cubit.stream, emitsInOrder(expected));
      cubit.fetchCachedData();
      verify(usecase(NoParams())).called(1);
      verifyNoMoreInteractions(usecase);
    });

    test('cache error', () async {
      when(usecase(NoParams())).thenAnswer(
        (_) async => Left(CacheFailure()),
      );
      final expected = [
        AuthenticationLoading(),
        AuthenticationError(),
      ];
      expectLater(cubit.stream, emitsInOrder(expected));
      cubit.fetchCachedData();
      verify(usecase(NoParams())).called(1);
      verifyNoMoreInteractions(usecase);
    });
  });
}
