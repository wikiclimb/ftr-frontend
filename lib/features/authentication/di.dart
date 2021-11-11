// coverage:ignore-file

import 'package:get_it/get_it.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/usecases/authenticate.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/presentation/bloc/authentication_bloc.dart';

import 'data/datasources/authentication_local_data_source.dart';
import 'data/repositories/authentication_repository_impl.dart';
import 'domain/repositories/authentication_repository.dart';

void initAuthenticationFeature(GetIt sl) {
  // Bloc
  sl.registerFactory(
    () => AuthenticationBloc(
      usecase: sl(),
    ),
  );
  // Usecases
  sl.registerLazySingleton(() => Authenticate(sl()));
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
