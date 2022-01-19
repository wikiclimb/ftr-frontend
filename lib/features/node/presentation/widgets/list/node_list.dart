import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../bloc/node_list/node_list_bloc.dart';
import 'node_list_item.dart';

/// Renders a list of [Node] provided by a bloc in the context.
///
/// This widget manages reacting to BLoC states and handling scrolling events.
class NodeList extends StatefulWidget {
  const NodeList({Key? key}) : super(key: key);

  @override
  State<NodeList> createState() => _NodeListState();
}

class _NodeListState extends State<NodeList> {
  final nodes = const [];

  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom) {
      final bloc = context.read<NodeListBloc>();
      if (bloc.state.nextPage > 0) {
        bloc.add(NextPageRequested());
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NodeListBloc, NodeListState>(builder: (context, state) {
      switch (state.status) {
        case NodeListStatus.initial:
        case NodeListStatus.loading:
          return const Center(child: CircularProgressIndicator());
        default:
          // Handle loading and loaded status here.
          if (state.nodes.isNotEmpty) {
            return CustomScrollView(
              key: const Key('nodeList_nodesCustomScrollView'),
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  expandedHeight: MediaQuery.of(context).padding.top + 16,
                  elevation: 16,
                  automaticallyImplyLeading: false,
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index == state.nodes.length) {
                        return NodeListLastItem(
                          key: const Key('nodeList_nodeListLastItem'),
                          state: state,
                        );
                      } else {
                        return NodeListItem(
                          key: ValueKey(state.nodes.elementAt(index).hashCode),
                          node: state.nodes.elementAt(index),
                        );
                      }
                    },
                    childCount: state.nodes.length + 1,
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: Text(AppLocalizations.of(context)!.noItems),
            );
          }
      }
    });
  }
}

/// This widget uses the current state to build a ListTile
class NodeListLastItem extends StatelessWidget {
  const NodeListLastItem({Key? key, required this.state}) : super(key: key);

  final NodeListState state;

  @override
  Widget build(BuildContext context) {
    if (state.status == NodeListStatus.loaded && state.hasError) {
      return ListTile(
        title: Text(AppLocalizations.of(context)!.hasAnError),
      );
    } else if (state.status == NodeListStatus.loading) {
      return const ListTile(
        title: CircularProgressIndicator(),
      );
    }
    return ListTile(
      title: state.nextPage == -1
          ? Text(AppLocalizations.of(context)!.noMoreItems)
          : const SizedBox(height: 24),
    );
  }
}
