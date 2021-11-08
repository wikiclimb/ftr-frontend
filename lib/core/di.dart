// coverage:ignore-file
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'network/network_info.dart';

void initCore(GetIt sl) {
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton<InternetConnectionChecker>(
      () => InternetConnectionChecker());
}
