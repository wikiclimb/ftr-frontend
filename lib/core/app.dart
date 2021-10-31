import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  final String title = 'WikiClimb';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text(title)),
        body: const Center(
          child: SizedBox(
            width: 200,
            child: Image(
              image: AssetImage('graphics/wikiclimb-logo.png'),
            ),
          ),
        ),
      ),
    );
  }
}
