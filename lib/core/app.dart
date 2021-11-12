import 'package:flutter/material.dart';

import '../features/home/presentation/screens/home_screen.dart';
import '../features/login/presentation/screens/login_screen.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  final String title = 'WikiClimb';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: HomeScreen.id,
      routes: {
        // coverage:ignore-start
        HomeScreen.id: (context) => const HomeScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        // coverage:ignore-end
      },
    );
  }
}
