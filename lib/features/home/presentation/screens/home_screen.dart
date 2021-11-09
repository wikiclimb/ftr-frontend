import 'package:flutter/material.dart';

import '../../../../core/widgets/navigation/main_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String id = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WikiClimb')),
      drawer: const MainDrawer(currentRoute: HomeScreen.id),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const <Widget>[
          Center(
            child: SizedBox(
              width: 200,
              child: Image(
                image: AssetImage('graphics/wikiclimb-logo.png'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
