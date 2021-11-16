// coverage:ignore-file
import 'package:get_it/get_it.dart';

import 'data/datasources/node_remote_data_source.dart';
import 'data/repositories/node_repository_impl.dart';
import 'domain/repositories/node_repository.dart';

void initNodeFeature(GetIt sl) {
  // Bloc

  // Usecases

  // Repository
  // This repository has multiple subscribers, ensure that
  // each one gets its own independent [Stream].
  sl.registerFactory<NodeRepository>(
    () => NodeRepositoryImpl(remoteDataSource: sl()),
  );
  // Data sources
  sl.registerLazySingleton<NodeRemoteDataSource>(
      () => NodeRemoteDataSourceImpl(client: sl()));
}
