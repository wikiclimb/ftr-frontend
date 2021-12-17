// coverage:ignore-file
import 'package:get_it/get_it.dart';

import 'data/repositories/area_repository_impl.dart';
import 'domain/repository/area_repository.dart';

void initAreaFeature(GetIt sl) {
  // Bloc
  // Usecases
  // Repository
  sl.registerLazySingleton<AreaRepository>(
    () => AreaRepositoryImpl(
      nodeRepository: sl(),
    ),
  );
  // Data sources
}
