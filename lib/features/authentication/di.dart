// coverage:ignore-file
import 'package:get_it/get_it.dart';

import 'data/datasources/authentication_local_data_source.dart';
import 'data/datasources/authentication_remote_data_source.dart';
import 'data/repositories/authentication_repository_impl.dart';
import 'domain/repositories/authentication_repository.dart';
import 'domain/usecases/log_in_with_username_password.dart';
import 'presentation/bloc/login_bloc.dart';

void initAuthenticationFeature(GetIt sl) {
  // Bloc
  sl.registerFactory(() => LoginBloc(loginUsecase: sl()));
  // Usecases
  sl.registerLazySingleton(() => LogInWithUsernamePassword(sl()));
  // Repository
  sl.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  // Data sources
  sl.registerLazySingleton<AuthenticationRemoteDataSource>(
    () => AuthenticationRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<AuthenticationLocalDataSource>(
    () => AuthenticationLocalDataSourceImpl(sharedPreferences: sl()),
  );
}
