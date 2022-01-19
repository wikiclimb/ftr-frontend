import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../features/authentication/presentation/bloc/authentication_bloc.dart';
import '../../../features/login/presentation/screens/login_screen.dart';
import '../../../features/login/presentation/widgets/login_drawer_tile.dart';
import '../../../features/map/presentation/screens/map_screen.dart';
import '../../../features/node/presentation/screens/node_list_screen.dart';
import '../../../features/registration/presentation/screens/registration_screen.dart';

/// Main drawer provides the main application navigation menu.
///
/// This widget is in charge of creating the tiles that make up the application
/// navigation.
class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key, required this.currentRoute}) : super(key: key);

  final String currentRoute;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            if (currentRoute != MapScreen.id)
              const MapTile(key: Key('mainDrawer_mapDrawerTile')),
            const AreasTile(),
            const RoutesTile(),
            if (currentRoute != LoginScreen.id) const LoginDrawerTile(),
            if (context.read<AuthenticationBloc>().state
                    is AuthenticationUnauthenticated &&
                currentRoute != RegistrationScreen.id)
              const SignUpTile(key: Key('mainDrawer_registrationDrawerTile')),
          ],
        ),
      ),
    );
  }
}

class AreasTile extends StatelessWidget {
  const AreasTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: UniqueKey(),
      leading: const Icon(Icons.list_outlined),
      title: Text(AppLocalizations.of(context)!.areasLink),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NodeListScreen(type: 1),
          ),
        );
      },
    );
  }
}

class RoutesTile extends StatelessWidget {
  const RoutesTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: UniqueKey(),
      leading: const Icon(Icons.upgrade),
      title: Text(AppLocalizations.of(context)!.routesLink),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NodeListScreen(type: 2),
          ),
        );
      },
    );
  }
}

class MapTile extends StatelessWidget {
  const MapTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: const Key('mainDrawer_mapListTile'),
      leading: const Icon(Icons.map),
      title: Text(AppLocalizations.of(context)!.mapLink),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, MapScreen.id);
      },
    );
  }
}

class SignUpTile extends StatelessWidget {
  const SignUpTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.app_registration),
      title: Text(AppLocalizations.of(context)!.signUp),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, RegistrationScreen.id);
      },
    );
  }
}
