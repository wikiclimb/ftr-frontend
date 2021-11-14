import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wikiclimb_flutter_frontend/core/error/failure.dart';
import 'package:wikiclimb_flutter_frontend/core/usecases/usecase.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/usecases/logout.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  late Logout usecase;
  late AuthenticationRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthenticationRepository();
    usecase = Logout(mockRepository);
  });

  test('should forward the call to the repository', () async {
    when(() => mockRepository.logout()).thenAnswer((_) async => true);
    final result = await usecase(NoParams());
    expect(result, const Right(true));
    verify(() => mockRepository.logout()).called(1);
  });

  test('should return Right(true) on success', () async {
    when(() => mockRepository.logout()).thenAnswer((_) async => true);
    final result = await usecase(NoParams());
    expect(result, const Right(true));
  });

  test('should return Left(CacheFailure) on failed', () async {
    when(() => mockRepository.logout()).thenAnswer((_) async => false);
    final result = await usecase(NoParams());
    expect(result, Left(CacheFailure()));
    verify(() => mockRepository.logout()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
