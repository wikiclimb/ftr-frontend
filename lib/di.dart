// coverage:ignore-file
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'core/authentication/authentication_provider.dart';
import 'core/di.dart';
import 'core/utils/locator.dart';
import 'features/area/di.dart';
import 'features/authentication/di.dart';
import 'features/image/di.dart';
import 'features/login/di.dart';
import 'features/map/di.dart';
import 'features/node/di.dart';
import 'features/password_recovery/di.dart';
import 'features/registration/di.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Global dependencies
  sl.registerLazySingleton<AuthenticationProvider>(
    () => AuthenticationProviderImpl(),
  );
  initAreaFeature(sl);
  initAuthenticationFeature(sl);
  initImageFeature(sl);
  initLoginFeature(sl);
  initMapFeature(sl);
  initNodeFeature(sl);
  initPasswordRecoveryFeature(sl);
  initRegistrationFeature(sl);
  initCore(sl);
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton<Locator>(() => LocatorImpl());
}
