import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/error/failure.dart';
import '../entities/authentication_data.dart';

import '../repositories/authentication_repository.dart';

class LogInWithUsernamePassword extends UseCase<AuthenticationData, Params> {
  LogInWithUsernamePassword(this.repository);

  final AuthenticationRepository repository;

  @override
  Future<Either<Failure, AuthenticationData>> call(Params params) async {
    return await repository.logInWithUsernamePassword(
        username: params.username, password: params.password);
  }
}

class Params extends Equatable {
  final String username;
  final String password;

  const Params({required this.username, required this.password});

  // coverage:ignore-start
  @override
  List<Object?> get props => [username, password];
  // coverage:ignore-end
}
