import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wikiclimb_flutter_frontend/core/error/failure.dart';

import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/node.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/repositories/node_repository.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/usecases/edit_node.dart';

class MockNodeRepository extends Mock implements NodeRepository {}

void main() {
  late NodeRepository mockNodeRepository;
  late EditNode usecase;

  setUp(() {
    mockNodeRepository = MockNodeRepository();
    usecase = EditNode(mockNodeRepository);
  });

  group('create', () {
    final newNode = Node((n) => n
      ..type = 1
      ..name = 'test-area-1'
      ..description = 'test-area-description');

    group('success responses', () {
      test('usecase pipes success response', () async {
        final tResponse = newNode.rebuild((n) => n..id = 123);
        when(() => mockNodeRepository.create(newNode))
            .thenAnswer((_) async => Right(tResponse));
        final response = await usecase(newNode);
        expect(response, Right(tResponse));
        verify(() => mockNodeRepository.create(newNode)).called(1);
        verifyNoMoreInteractions(mockNodeRepository);
      });
    });

    group('error responses', () {
      test('usecase pipes success response', () async {
        when(() => mockNodeRepository.create(newNode))
            .thenAnswer((_) async => Left(AuthenticationFailure()));
        final response = await usecase(newNode);
        expect(response, Left(AuthenticationFailure()));
        verify(() => mockNodeRepository.create(newNode)).called(1);
        verifyNoMoreInteractions(mockNodeRepository);
      });
    });
  });

  group('update', () {
    final existingNode = Node((n) => n
      ..id = 123
      ..type = 1
      ..name = 'test-area-1'
      ..description = 'test-area-description');
    group('success responses', () {
      test('usecase pipes success response', () async {
        final tResponse = existingNode.rebuild(
          (n) => n..createdBy = 'test-user-22',
        );
        when(() => mockNodeRepository.update(existingNode))
            .thenAnswer((_) async => Right(tResponse));
        final response = await usecase(existingNode);
        expect(response, Right(tResponse));
        verify(() => mockNodeRepository.update(existingNode)).called(1);
        verifyNoMoreInteractions(mockNodeRepository);
      });
    });

    group('error responses', () {
      test('usecase pipes success response', () async {
        when(() => mockNodeRepository.update(existingNode))
            .thenAnswer((_) async => Left(AuthenticationFailure()));
        final response = await usecase(existingNode);
        expect(response, Left(AuthenticationFailure()));
        verify(() => mockNodeRepository.update(existingNode)).called(1);
        verifyNoMoreInteractions(mockNodeRepository);
      });
    });
  });
}
