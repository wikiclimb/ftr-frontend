// coverage:ignore-file
import 'package:get_it/get_it.dart';

import 'data/datasources/password_recovery_remote_data_source.dart';
import 'data/repositories/password_recovery_repository_impl.dart';
import 'domain/repositories/password_recovery_repository.dart';
import 'domain/usecases/request_password_recovery_email.dart';
import 'presentation/bloc/password_recovery/password_recovery_bloc.dart';

void initPasswordRecoveryFeature(GetIt sl) {
  // Bloc
  sl.registerFactory(
      () => PasswordRecoveryBloc(requestPasswordRecoveryEmailUseCase: sl()));
  // Usecases
  sl.registerLazySingleton<RequestPasswordRecoveryEmail>(
      () => RequestPasswordRecoveryEmail(sl()));
  // Repository
  sl.registerLazySingleton<PasswordRecoveryRepository>(
    () => PasswordRecoveryRepositoryImpl(sl()),
  );
  // Data sources
  sl.registerLazySingleton<PasswordRecoveryRemoteDataSource>(
    () => PasswordRecoveryRemoteDataSourceImpl(
      client: sl(),
    ),
  );
}
