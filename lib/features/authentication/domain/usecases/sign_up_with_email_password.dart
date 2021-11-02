import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wikiclimb_flutter_frontend/core/usecases/usecase.dart';
import '../../../../core/error/failure.dart';
import '../entities/authentication_data.dart';

import '../repositories/authentication_repository.dart';

class SignUpWithEmailPassword extends UseCase<AuthenticationData, Params> {
  SignUpWithEmailPassword(this.repository);

  final AuthenticationRepository repository;

  @override
  Future<Either<Failure, AuthenticationData>> call(Params params) async {
    return await repository.signUpWithEmailPassword(
        email: params.email, password: params.password);
  }
}

class Params extends Equatable {
  final String email;
  final String password;

  const Params({required this.email, required this.password});

  // coverage:ignore-start
  @override
  List<Object?> get props => [email, password];
  // coverage:ignore-end
}
