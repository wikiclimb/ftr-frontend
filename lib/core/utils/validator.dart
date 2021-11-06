import 'package:dartz/dartz.dart';
import 'package:email_validator/email_validator.dart';
import 'package:wikiclimb_flutter_frontend/core/error/failure.dart';

/// The parent class for validators.
abstract class Validator {
  Future<Either<Failure, String>> validateEmail(String email);
}

class ValidatorImpl implements Validator {
  @override
  Future<Either<Failure, String>> validateEmail(String email) {
    if (EmailValidator.validate(email)) {
      return Future.value(Right(email));
    }
    return Future.value(const Left(ValidationFailure('Email is not valid')));
  }
}

class ValidationFailure extends Failure {
  const ValidationFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
