import 'package:wikiclimb_flutter_frontend/core/platform/network_info.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/data/datasources/authentication_local_data_source.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/entities/authentication_data.dart';
import 'package:wikiclimb_flutter_frontend/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/repositories/authentication_repository.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthenticationRemoteDataSource remoteDataSource;
  final AuthenticationLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthenticationRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, AuthenticationData>> logInWithUsernamePassword(
      {required String username, required String password}) {
    // TODO: implement logInWithUsernamePassword
    throw UnimplementedError();
  }
}
