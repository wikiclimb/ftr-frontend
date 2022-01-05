// coverage:ignore-file
import 'package:get_it/get_it.dart';

import 'data/datasources/password_recovery_remote_data_source.dart';
import 'data/repositories/password_recovery_repository_impl.dart';
import 'domain/repositories/password_recovery_repository.dart';

void initRegistrationFeature(GetIt sl) {
  // Bloc
  // Usecases
  // Repository
  sl.registerFactory<PasswordRecoveryRepository>(
    () => PasswordRecoveryRepositoryImpl(sl()),
  );
  // Data sources
  sl.registerLazySingleton<PasswordRecoveryRemoteDataSource>(
    () => PasswordRecoveryRemoteDataSourceImpl(
      client: sl(),
    ),
  );
}
