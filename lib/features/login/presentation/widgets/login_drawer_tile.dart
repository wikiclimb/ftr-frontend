import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../authentication/presentation/bloc/authentication_bloc.dart';
import '../screens/login_screen.dart';

/// Render a [LoginTile] or [LogoutTile] depending on authentication status.
class LoginDrawerTile extends StatelessWidget {
  const LoginDrawerTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      if (state is AuthenticationAuthenticated) {
        return const LogoutTile();
      }
      // If the state is initial or unauthenticated show the login tile.
      return const LoginTile();
    });
  }
}

/// Render a tile that lets the user navigate to the [LoginScreen].
class LoginTile extends StatelessWidget {
  const LoginTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: UniqueKey(),
      leading: const Icon(Icons.login),
      title: Text(AppLocalizations.of(context)!.logIn),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, LoginScreen.id);
      },
    );
  }
}

/// Render a tile that lets the user request to logout.
class LogoutTile extends StatelessWidget {
  const LogoutTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: UniqueKey(),
      leading: const Icon(Icons.logout),
      title: Text(AppLocalizations.of(context)!.logOut),
      onTap: () {
        // Hide the drawer.
        Navigator.pop(context);
        // Request logout.
        context.read<AuthenticationBloc>().add(LogoutRequested());
        // Navigate to [HomeScreen].
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
    );
  }
}
