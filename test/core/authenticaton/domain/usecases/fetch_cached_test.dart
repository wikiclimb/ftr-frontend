import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:wikiclimb_flutter_frontend/core/authentication/domain/entities/authentication_data.dart';
import 'package:wikiclimb_flutter_frontend/core/authentication/domain/repositories/authentication_repository.dart';
import 'package:wikiclimb_flutter_frontend/core/authentication/domain/usecases/fetch_cached.dart';
import 'package:wikiclimb_flutter_frontend/core/error/failure.dart';
import 'package:wikiclimb_flutter_frontend/core/usecases/usecase.dart';

import 'fetch_cached_test.mocks.dart';

@GenerateMocks([AuthenticationRepository])
void main() {
  late FetchCached usecase;
  late MockAuthenticationRepository repository;
  const tAuthenticationData = AuthenticationData(
    token: 'secret-token',
    id: 123,
  );

  setUp(() {
    repository = MockAuthenticationRepository();
    usecase = FetchCached(repository);
  });

  test('should return authentication data when found', () async {
    when(repository.getAuthenticationData())
        .thenAnswer((_) async => const Right(tAuthenticationData));
    final result = await usecase(NoParams());
    expect(result, const Right(tAuthenticationData));
    verify(repository.getAuthenticationData()).called(1);
    verifyNoMoreInteractions(repository);
  });

  test('should return failure when data not found', () async {
    when(repository.getAuthenticationData())
        .thenAnswer((_) async => Left(AuthenticationFailure()));
    final result = await usecase(NoParams());
    expect(result, Left(AuthenticationFailure()));
    verify(repository.getAuthenticationData()).called(1);
    verifyNoMoreInteractions(repository);
  });
}
