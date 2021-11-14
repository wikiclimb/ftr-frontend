import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/authentication_repository.dart';

/// Contract for the logout use case.
class Logout extends UseCase<bool, NoParams> {
  Logout(this.repository);

  final AuthenticationRepository repository;

  /// Return [Right] if the user could be logged out, [CacheFailure] otherwise.
  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    if (await repository.logout()) {
      return const Right(true);
    }
    return Left(CacheFailure());
  }
}
