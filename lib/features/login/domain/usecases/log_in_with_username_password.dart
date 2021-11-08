import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/authentication/domain/entities/authentication_data.dart';
import '../repositories/login_repository.dart';

class LogInWithUsernamePassword extends UseCase<AuthenticationData, Params> {
  LogInWithUsernamePassword(this.repository);

  final LoginRepository repository;

  @override
  Future<Either<Failure, AuthenticationData>> call(Params params) async {
    return await repository.logInWithUsernamePassword(
        username: params.username, password: params.password);
  }
}

class Params extends Equatable {
  const Params({required this.username, required this.password});

  final String password;
  final String username;

  // coverage:ignore-start
  @override
  List<Object?> get props => [username, password];

  // coverage:ignore-end
}
