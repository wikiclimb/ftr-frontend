import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'core/app.dart';
import 'di.dart' as di;
import 'features/authentication/presentation/bloc/authentication_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  // Trigger authentication check on startup.
  final GetIt sl = GetIt.instance;
  final authCubit = sl<AuthenticationBloc>();
  runApp(BlocProvider<AuthenticationBloc>(
    create: (BuildContext context) => authCubit,
    child: const App(),
  ));
}
