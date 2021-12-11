// coverage:ignore-file
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'database/database.dart';
import 'database/production_database_config.dart';
import 'environment/environment_config.dart';
import 'network/network_info.dart';

void initCore(GetIt sl) {
  const dbManager = DatabaseManagerImpl(
    databaseName: EnvironmentConfig.databaseName,
  );
  sl.registerLazySingleton<WkcDatabase>(
    () => WkcDatabase(
      dbManager.openProductionDatabase(),
    ),
  );
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton<InternetConnectionChecker>(
      () => InternetConnectionChecker());
}
