import 'package:dartz/dartz.dart';

import '../../../../core/entities/response.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/sign_up_params.dart';
import '../repositories/registration_repository.dart';

/// Lets a user sign up to the platform using their email.
///
/// It asks the user to submit a username and password, as well as their email.
/// The account created will be inactive until validated clicking on a link
/// sent by email.
class SignUpWithEmailPassword extends UseCase<Response, SignUpParams> {
  SignUpWithEmailPassword(this.repository);
  final RegistrationRepository repository;

  @override
  Future<Either<Failure, Response>> call(params) =>
      repository.signUpWithEmailPassword(params);
}
