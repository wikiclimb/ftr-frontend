import 'package:flutter/material.dart';

import '../../../features/login/presentation/screens/login_screen.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key, required this.currentRoute}) : super(key: key);

  final String currentRoute;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          ListTile(
            key: UniqueKey(),
            leading: const Icon(Icons.login),
            enabled: currentRoute != LoginScreen.id,
            title: const Text('Login'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, LoginScreen.id);
            },
          ),
        ],
      ),
    );
  }
}
