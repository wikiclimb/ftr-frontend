// coverage:ignore-file
import 'package:get_it/get_it.dart';

import 'data/datasources/registration_remote_data_source.dart';
import 'data/repositories/registration_repository_impl.dart';
import 'domain/repositories/registration_repository.dart';
import 'domain/usecases/sign_up_with_email_password.dart';
import 'presentation/bloc/registration/registration_bloc.dart';

void initRegistrationFeature(GetIt sl) {
  // Bloc
  sl.registerFactory<RegistrationBloc>(
    () => RegistrationBloc(signUp: sl()),
  );
  // Usecases
  sl.registerLazySingleton<SignUpWithEmailPassword>(
      () => SignUpWithEmailPassword(sl()));
  // Repository
  sl.registerFactory<RegistrationRepository>(
    () => RegistrationRepositoryImpl(sl()),
  );
  // Data sources
  sl.registerLazySingleton<RegistrationRemoteDataSource>(
    () => RegistrationRemoteDataSourceImpl(
      client: sl(),
    ),
  );
}
