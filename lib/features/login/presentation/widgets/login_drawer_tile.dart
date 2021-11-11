import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../authentication/presentation/bloc/authentication_bloc.dart';

import '../screens/login_screen.dart';

class LoginDrawerTile extends StatelessWidget {
  const LoginDrawerTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      if (state is AuthenticationAuthenticated) {
        return const LogoutTile();
      }
      if (state is AuthenticationUnauthenticated) {
        return const LoadingAuthenticationDataTile();
      }
      return const LoginTile();
    });
  }
}

class LoginTile extends StatelessWidget {
  const LoginTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: UniqueKey(),
      leading: const Icon(Icons.login),
      title: const Text('Login'),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, LoginScreen.id);
      },
    );
  }
}

class LogoutTile extends StatelessWidget {
  const LogoutTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: UniqueKey(),
      leading: const Icon(Icons.logout),
      title: const Text('Logout'),
      // TODO create a logout usecase.
      onTap: null,
    );
  }
}

class LoadingAuthenticationDataTile extends StatelessWidget {
  const LoadingAuthenticationDataTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: UniqueKey(),
      leading: const Icon(Icons.login),
      title: const CircularProgressIndicator(),
      onTap: null,
    );
  }
}
