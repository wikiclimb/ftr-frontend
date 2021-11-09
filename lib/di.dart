// coverage:ignore-file
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'core/di.dart';
import 'features/login/di.dart';

final sl = GetIt.instance;

Future<void> init() async {
  initLoginFeature(sl);
  initCore(sl);
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
}
