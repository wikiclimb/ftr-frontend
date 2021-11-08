import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/form/decorated_icon_input.dart';
import '../../../../di.dart';
import '../bloc/login_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const String id = '/login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log in'),
      ),
      body: BlocProvider(
        create: (context) => sl<LoginBloc>(),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
            ),
            child: Center(
              child: ListView(
                children: <Widget>[
                  const WkcLogo(),
                  BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
                    if (state is LoginInitial) {
                      return loginForm(context);
                    } else if (state is LoginSuccess) {
                      return const Center(
                        child: Text('success'),
                      );
                    } else if (state is LoginError) {
                      return const Center(
                        child: Text('Error'),
                      );
                    } else if (state is LoginLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return const Center(
                        child: Text('Default state'),
                      );
                    }
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget loginForm(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const DecoratedIconInput(
        key: ValueKey('username-input'),
        hintText: 'Username',
        prefixIcon: Icons.person,
      ),
      const SizedBox(
        height: 24,
      ),
      const DecoratedIconInput(
        key: ValueKey('password-input'),
        hintText: 'Password',
        prefixIcon: Icons.lock,
      ),
      const SizedBox(
        height: 24,
      ),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.blue,
          padding: const EdgeInsets.symmetric(
            vertical: 16,
          ),
          textStyle: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          BlocProvider.of<LoginBloc>(context).add(
            const LoginRequested(
              username: 'username',
              password: 'password',
            ),
          );
        },
        child: const Text('Log in'),
      ),
      const SizedBox(
        height: 16,
      ),
      const ElevatedButton(
        onPressed: null,
        child: Text('I forgot my password'),
      ),
    ],
  );
}

class WkcLogo extends StatelessWidget {
  const WkcLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Image(
          image: AssetImage('graphics/wikiclimb-logo.png'),
        ),
      ),
    );
  }
}
