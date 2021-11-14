import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/navigation/main_drawer.dart';
import '../../../authentication/presentation/bloc/authentication_bloc.dart';

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
        children: <Widget>[
          const Center(
            child: SizedBox(
              width: 200,
              child: Image(
                image: AssetImage('graphics/wikiclimb-logo.png'),
              ),
            ),
          ),
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              if (state is AuthenticationAuthenticated) {
                return Text('Hello ${state.authenticationData.username}');
              } else {
                return const Text('Hello guest');
              }
            },
          ),
        ],
      ),
    );
  }
}
