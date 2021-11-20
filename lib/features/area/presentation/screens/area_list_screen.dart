import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/area/presentation/screens/add_area_screen.dart';
import 'package:wikiclimb_flutter_frontend/features/area/presentation/widgets/area_list.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/presentation/bloc/authentication_bloc.dart';

import '../../../../di.dart';
import '../bloc/list/areas_bloc.dart';

/// Display a list of areas in the system.
///
/// This class manages providing:
/// - An entry point for the area list route.
/// - An [AreasBloc] in the context for children to use.
class AreaListScreen extends StatelessWidget {
  const AreaListScreen({Key? key}) : super(key: key);

  static const String id = '/area-list';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Areas'),
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => sl<AreasBloc>(),
          child: const AreaList(),
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
