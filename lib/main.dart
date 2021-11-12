import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'core/app.dart';
import 'di.dart' as di;
import 'features/authentication/presentation/bloc/authentication_bloc.dart';

void main() async {
  // Setup dependency injection.
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  final GetIt sl = GetIt.instance;
  final authBloc = sl<AuthenticationBloc>();

  // Trigger authentication check on startup.
  authBloc.add(AuthenticationRequested());

  // Launch the app.
  runApp(BlocProvider<AuthenticationBloc>(
    create: (BuildContext context) => authBloc,
    child: const App(),
  ));
}
