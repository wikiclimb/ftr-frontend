import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:wikiclimb_flutter_frontend/core/error/failure.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/entities/authentication_data.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/usecases/authenticate.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  late Authenticate usecase;
  late MockAuthenticationRepository repository;
  const tAuthenticationData = AuthenticationData(
    token: 'secret-token',
    id: 123,
  );

  setUp(() {
    repository = MockAuthenticationRepository();
    usecase = Authenticate(repository);
  });

  test('should pass call to repository', () async {
    when(() => repository.authenticationData).thenAnswer(
      (_) => Stream.value(const Right(tAuthenticationData)),
    );
    expectLater(
      usecase.subscribe,
      emitsInOrder([const Right(tAuthenticationData)]),
    );
    usecase();
    verify(() => repository.checkAuthenticatedData()).called(1);
  });

  test('should return failure when data not found', () async {
    when(() => repository.authenticationData).thenAnswer(
      (_) => Stream.value(Left(AuthenticationFailure())),
    );
    expectLater(
      usecase.subscribe,
      emitsInOrder([Left(AuthenticationFailure())]),
    );
    usecase();
    verify(() => repository.checkAuthenticatedData()).called(1);
  });
}
