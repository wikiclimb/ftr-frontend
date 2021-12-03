import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/map/presentation/screens/map_screen.dart';

import '../../../features/area/presentation/screens/area_list_screen.dart';
import '../../../features/authentication/presentation/bloc/authentication_bloc.dart';
import '../../../features/login/presentation/screens/login_screen.dart';
import '../../../features/login/presentation/widgets/login_drawer_tile.dart';
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
            if (currentRoute != AreaListScreen.id) const AreasTile(),
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
      title: const Text('Areas'),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, AreaListScreen.id);
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
      title: const Text('Map'),
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
      title: const Text('Sign Up'),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, RegistrationScreen.id);
      },
    );
  }
}
