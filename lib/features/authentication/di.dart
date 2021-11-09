// coverage:ignore-file

import 'package:get_it/get_it.dart';

import 'data/datasources/authentication_local_data_source.dart';
import 'data/repositories/authentication_repository_impl.dart';
import 'domain/repositories/authentication_repository.dart';
import 'domain/usecases/fetch_cached.dart';
import 'presentation/bloc/authentication_cubit.dart';

void initAuthenticationFeature(GetIt sl) {
  // Bloc
  sl.registerFactory(
    () => AuthenticationCubit(
      fetchCachedUsecase: sl(),
    ),
  );
  // Usecases
  sl.registerLazySingleton(() => FetchCached(sl()));
  // Repository
  sl.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepositoryImpl(
      localDataSource: sl(),
    ),
  );
  // Data sources
  sl.registerLazySingleton<AuthenticationLocalDataSource>(
    () => AuthenticationLocalDataSourceImpl(sharedPreferences: sl()),
  );
}
