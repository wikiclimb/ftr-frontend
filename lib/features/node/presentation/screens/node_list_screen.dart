import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../di.dart';
import '../../../authentication/presentation/bloc/authentication_bloc.dart';
import '../bloc/node_list/node_list_bloc.dart';
import '../widgets/list/node_list.dart';
import '../widgets/search/node_search_bar.dart';
import 'add_node_screen.dart';

/// Displays a list of [Node]. The list can be filtered by type.
///
/// This Widget is in charge of providing an entry point for screens that
class NodeListScreen extends StatelessWidget {
  const NodeListScreen({this.type, Key? key}) : super(key: key);

  final int? type;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // This is handled by the search bar itself.
      resizeToAvoidBottomInset: false,
      body: BlocProvider(
        create: (context) => sl<NodeListBloc>(param1: null, param2: type),
        child: Stack(
          fit: StackFit.expand,
          children: const [
            NodeList(),
            NodeSearchBar(),
          ],
        ),
      ),
      floatingActionButton:
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationAuthenticated && type != null) {
            return FloatingActionButton(
              key: const Key('nodeListScreen_addNewNode_fab'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddNodeScreen(type: type!),
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
