import 'package:flutter/material.dart';

import '../../../features/area/presentation/screens/area_list_screen.dart';
import '../../../features/login/presentation/screens/login_screen.dart';
import '../../../features/login/presentation/widgets/login_drawer_tile.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key, required this.currentRoute}) : super(key: key);

  final String currentRoute;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          if (currentRoute != AreaListScreen.id)
            ListTile(
              key: UniqueKey(),
              leading: const Icon(Icons.list_outlined),
              title: const Text('Areas'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AreaListScreen.id);
              },
            ),
          if (currentRoute != LoginScreen.id) const LoginDrawerTile(),
        ],
      ),
    );
  }
}
