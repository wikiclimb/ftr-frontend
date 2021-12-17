import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

import '../../bloc/node_list/node_list_bloc.dart';

/// Manage the search functionality for the node list screen.
///
/// This widget can access an instance of [NodeListBloc] through the context.
class NodeSearchBar extends StatelessWidget {
  const NodeSearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      key: const Key('nodeListScreen_floatingSearchBar'),
      hint: 'Search...',
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 100),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {
        context.read<NodeListBloc>().add(SearchQueryUpdated(query: query));
      },
      transition: CircularFloatingSearchBarTransition(),
      clearQueryOnClose: false,
      actions: [
        FloatingSearchBarAction.searchToClear(
            // showIfClosed: true,
            ),
      ],
      builder: (context, transition) => Container(),
    );
  }
}
