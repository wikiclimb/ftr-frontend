import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'core/app.dart';
import 'core/logs/bloc_observer.dart';
import 'di.dart' as di;
import 'features/authentication/presentation/bloc/authentication_bloc.dart';

/// Main provides the application with its dependencies and launches it.
void main() async {
  // Setup dependency injection.
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  final GetIt sl = GetIt.instance;

  // Setup application blocs
  if (kDebugMode) {
    Bloc.observer = MyBlocObserver();
  }
  final authBloc = sl<AuthenticationBloc>();

  // Launch the app.
  runApp(BlocProvider<AuthenticationBloc>(
    create: (BuildContext context) => authBloc,
    child: const App(),
  ));
}
