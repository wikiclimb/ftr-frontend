// coverage:ignore-file
import 'package:get_it/get_it.dart';

import 'data/datasources/login_remote_data_source.dart';
import 'data/repositories/login_repository_impl.dart';
import 'domain/repositories/login_repository.dart';
import 'domain/usecases/log_in_with_username_password.dart';
import 'presentation/bloc/login_bloc.dart';

void initLoginFeature(GetIt sl) {
  // Bloc
  sl.registerFactory(() => LoginBloc(loginUseCase: sl()));
  // Usecases
  sl.registerLazySingleton(() => LogInWithUsernamePassword(sl()));
  // Repository
  sl.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(
      remoteDataSource: sl(),
      authenticationRepository: sl(),
    ),
  );
  // Data sources
  sl.registerLazySingleton<LoginRemoteDataSource>(
    () => LoginRemoteDataSourceImpl(
      client: sl(),
      networkInfo: sl(),
    ),
  );
}
