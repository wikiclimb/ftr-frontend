import 'package:dartz/dartz.dart';

import '../../../../core/usecases/usecase.dart';
import '../repositories/authentication_repository.dart';
import '../entities/authentication_data.dart';
import '../../../../core/error/failure.dart';

class FetchCached extends UseCase<AuthenticationData, NoParams> {
  FetchCached(this.repository);

  final AuthenticationRepository repository;

  @override
  Future<Either<Failure, AuthenticationData>> call(NoParams params) async {
    return await repository.getAuthenticationData();
  }
}
