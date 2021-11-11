import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/form/decorated_icon_input.dart';
import '../bloc/login_bloc.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const DecoratedIconInput(
          key: Key('username-input'),
          hintText: 'Username',
          prefixIcon: Icons.person,
        ),
        const SizedBox(
          height: 24,
        ),
        const DecoratedIconInput(
          key: Key('password-input'),
          hintText: 'Password',
          prefixIcon: Icons.lock,
        ),
        const SizedBox(
          height: 24,
        ),
        ElevatedButton(
          key: const Key('login-button'),
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
}
