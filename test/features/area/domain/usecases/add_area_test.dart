import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wikiclimb_flutter_frontend/core/error/failure.dart';

import 'package:wikiclimb_flutter_frontend/features/area/domain/repository/area_repository.dart';
import 'package:wikiclimb_flutter_frontend/features/area/domain/usecases/add_area.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/node.dart';

class MockAreaRepository extends Mock implements AreaRepository {}

void main() {
  late AreaRepository mockAreaRepository;
  late AddArea usecase;
  final tArea1 = Node((n) => n
    ..type = 1
    ..name = 'test-area-1'
    ..description = 'test-area-description');

  setUp(() {
    mockAreaRepository = MockAreaRepository();
    usecase = AddArea(mockAreaRepository);
  });

  group('success responses', () {
    test('usecase pipes success response', () async {
      final tResponse = tArea1.rebuild((n) => n..id = 123);
      when(() => mockAreaRepository.create(tArea1))
          .thenAnswer((_) async => Right(tResponse));
      final response = await usecase(tArea1);
      expect(response, Right(tResponse));
    });
  });

  group('error responses', () {
    test('usecase pipes success response', () async {
      when(() => mockAreaRepository.create(tArea1))
          .thenAnswer((_) async => Left(AuthenticationFailure()));
      final response = await usecase(tArea1);
      expect(response, Left(AuthenticationFailure()));
    });
  });
}
