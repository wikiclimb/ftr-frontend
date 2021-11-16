// coverage:ignore-file
import 'package:get_it/get_it.dart';
import 'package:wikiclimb_flutter_frontend/features/area/presentation/bloc/list/areas_bloc.dart';

import 'data/repositories/area_repository_impl.dart';
import 'domain/repository/area_repository.dart';
import 'domain/usecases/fetch_all.dart';

void initAreaFeature(GetIt sl) {
  // Bloc
  sl.registerFactory(() => AreasBloc(usecase: sl()));
  // Usecases
  sl.registerLazySingleton(() => FetchAllAreas(repository: sl()));
  // Repository
  sl.registerLazySingleton<AreaRepository>(
    () => AreaRepositoryImpl(
      nodeRepository: sl(),
    ),
  );
  // Data sources
}
