// coverage:ignore-file
import 'package:get_it/get_it.dart';

import 'domain/usecases/fetch_areas_with_bounds.dart';
import 'presentation/bloc/map_view/map_view_bloc.dart';

void initMapFeature(GetIt sl) {
  // Bloc
  sl.registerFactory<MapViewBloc>(
      () => MapViewBloc(fetchAreasWithBounds: sl()));
  // Usecases
  sl.registerLazySingleton(() => FetchAreasWithBounds(repository: sl()));
  // Repository

  // Data sources
}
