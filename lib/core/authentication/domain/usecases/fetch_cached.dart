import 'package:dartz/dartz.dart';
import 'package:wikiclimb_flutter_frontend/core/authentication/domain/repositories/authentication_repository.dart';
import '../entities/authentication_data.dart';
import '../../../error/failure.dart';
import '../../../usecases/usecase.dart';

class FetchCached extends UseCase<AuthenticationData, NoParams> {
  FetchCached(this.repository);

  final AuthenticationRepository repository;

  @override
  Future<Either<Failure, AuthenticationData>> call(NoParams params) async {
    return await repository.getAuthenticationData();
  }
}
