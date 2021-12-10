import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/area_search_bar.dart';
import '../../../../di.dart';
import '../../../authentication/presentation/bloc/authentication_bloc.dart';
import '../bloc/list/areas_bloc.dart';
import '../widgets/area_list.dart';
import 'add_area_screen.dart';

/// Display a list of areas in the system.
///
/// This class is in charge of providing an entry point for the area list route
/// and providing its children with an [AreasBloc] through the context.
class AreaListScreen extends StatelessWidget {
  const AreaListScreen({Key? key}) : super(key: key);

  static const String id = '/area-list';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // This is handled by the search bar itself.
      resizeToAvoidBottomInset: false,
      body: BlocProvider(
        create: (context) => sl<AreasBloc>(),
        child: Stack(
          fit: StackFit.expand,
          children: const [
            AreaList(),
            AreaSearchBar(),
          ],
        ),
      ),
      floatingActionButton:
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationAuthenticated) {
            return FloatingActionButton(
              key: const Key('add_area_fab'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddAreaScreen(),
                  ),
                );
              },
              child: const Icon(Icons.add),
            );
          }
          return Container();
        },
      ),
    );
  }
}
