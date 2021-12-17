import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/node.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/bloc/node_list/node_list_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/screens/add_node_screen.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/widgets/list/node_list.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/widgets/search/node_search_bar.dart';

import '../../../../../di.dart';

/// Renders a list of first level children of a given [Node].
///
/// This widget is similar to the [NodeListScreen] but it restricts the children
/// it displays to the first level children of a [Node] that it receives as a
/// constructor parameter. This widget is intended to help the user navigate
/// nodes going down one level at a time.
/// In the future it is possible that this screen could display multiple levels
/// of descendants using the search function to sort through them.
class NodeChildrenTab extends StatelessWidget {
  const NodeChildrenTab({Key? key, required this.parentNode}) : super(key: key);

  final Node parentNode;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NodeListBloc>(
      create: (_) => sl<NodeListBloc>(param1: parentNode),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const NodeList(),
          const NodeSearchBar(),
          Positioned(
            bottom: 24,
            right: 16,
            child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                if (state is AuthenticationAuthenticated) {
                  return FloatingActionButton(
                    heroTag: 'nodeDetailsScreen_nodeChildrenTab_addChild_fab',
                    key: const Key(
                        'nodeDetailsScreen_nodeChildrenTab_addChild_fab'),
                    child: const Icon(Icons.add),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddNodeScreen(
                            type: 1, // TODO maybe need to allow adding routes
                            parent: parentNode,
                          ),
                        ),
                      );
                    },
                  );
                }
                return Container();
              },
            ),
          )
        ],
      ),
    );
  }
}
