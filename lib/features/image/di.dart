// coverage:ignore-file
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:wikiclimb_flutter_frontend/core/environment/environment_config.dart';
import 'package:wikiclimb_flutter_frontend/features/image/domain/usecases/add_images_to_node.dart';

import 'data/datasources/image_remote_data_source.dart';
import 'data/repositories/image_repository_impl.dart';
import 'domain/repository/image_repository.dart';
import 'domain/usecases/fetch_all_images.dart';
import 'presentation/bloc/list/image_list_bloc.dart';

void initImageFeature(GetIt sl) {
  // Bloc
  sl.registerFactory<ImageListBloc>(
    () => ImageListBloc(usecase: sl()),
  );
  // Usecases
  sl.registerLazySingleton<FetchAllImages>(() => FetchAllImages(sl()));
  sl.registerLazySingleton<AddImagesToNode>(() => AddImagesToNode(sl()));
  // Repository
  // This repository has multiple subscribers, ensure that
  // each one gets its own independent [Stream].
  sl.registerFactory<ImageRepository>(
    () => ImageRepositoryImpl(sl()),
  );
  // Data sources
  sl.registerLazySingleton<ImageRemoteDataSource>(
    () => ImageRemoteDataSourceImpl(
      client: sl(),
      authenticationProvider: sl(),
      // TODO check if we can avoid hardcoding this.
      multipartRequest: http.MultipartRequest(
        'POST',
        Uri.https(EnvironmentConfig.apiUrl, 'images'),
      ),
    ),
  );
}
