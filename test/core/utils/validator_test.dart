import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wikiclimb_flutter_frontend/core/utils/validator.dart';

void main() {
  late ValidatorImpl validator;

  setUp(() {
    validator = ValidatorImpl();
  });

  group('email validator', () {
    test('should accept valid email', () async {
      const tEmail = 'someone@example.com';
      final result = await validator.validateEmail(tEmail);
      expect(result, const Right(tEmail));
    });

    test('should fail with invalid email', () async {
      const tEmail = 'wrong email';
      final result = await validator.validateEmail(tEmail);
      expect(result, const Left(ValidationFailure('Email is not valid')));
      result.fold(
          (failure) => {
                expect(failure.props, ['Email is not valid'])
              },
          (r) => null);
    });
  });
}
