// coverage:ignore-file
import 'package:get_it/get_it.dart';
import 'package:wikiclimb_flutter_frontend/features/node/data/datasources/drift_node_dao.dart';
import 'package:wikiclimb_flutter_frontend/features/node/data/datasources/node_local_data_source.dart';

import 'data/datasources/node_remote_data_source.dart';
import 'data/repositories/node_repository_impl.dart';
import 'domain/entities/node.dart';
import 'domain/repositories/node_repository.dart';
import 'domain/usecases/edit_node.dart';
import 'presentation/bloc/add_node_images/add_node_images_bloc.dart';
import 'presentation/bloc/node_edit/node_edit_bloc.dart';

void initNodeFeature(GetIt sl) {
  // Bloc
  sl.registerFactoryParam<NodeEditBloc, Node, void>(
    (node, _) => NodeEditBloc(editNode: sl(), locator: sl(), node: node),
  );
  sl.registerFactory<AddNodeImagesBloc>(
    () => AddNodeImagesBloc(sl()),
  );
  // Usecases
  sl.registerLazySingleton<EditNode>(() => EditNode(sl()));
  // Repository
  // This repository has multiple subscribers, ensure that
  // each one gets its own independent [Stream].
  sl.registerFactory<NodeRepository>(
    () => NodeRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );
  // Data sources
  sl.registerLazySingleton<NodeRemoteDataSource>(
    () => NodeRemoteDataSourceImpl(
      client: sl(),
      authenticationProvider: sl(),
    ),
  );
  sl.registerLazySingleton<NodeLocalDataSource>(
    () => NodeLocalDataSourceImpl(
      driftNodesDao: sl(),
    ),
  );
  sl.registerLazySingleton<DriftNodesDao>(() => DriftNodesDao(sl()));
}
