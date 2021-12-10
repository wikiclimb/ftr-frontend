import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/list/areas_bloc.dart';
import 'area_list_item.dart';

/// Renders a list of areas provided by a bloc in the context.
///
/// This widget manages reacting to BLoC states and handling scrolling events.
class AreaList extends StatefulWidget {
  const AreaList({Key? key}) : super(key: key);

  @override
  State<AreaList> createState() => _AreaListState();
}

class _AreaListState extends State<AreaList> {
  final areas = const [];

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
      final bloc = context.read<AreasBloc>();
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
    return BlocBuilder<AreasBloc, AreasState>(builder: (context, state) {
      switch (state.status) {
        case AreasStatus.initial:
        case AreasStatus.loading:
          return const Center(child: CircularProgressIndicator());
        default:
          // Handle loading and loaded status here.
          if (state.areas.isNotEmpty) {
            return ListView.builder(
              key: const Key('area-screen-area-list-list-builder'),
              controller: _scrollController,
              // Add one item to show the last tile.
              itemCount: state.areas.length + 1,
              itemBuilder: (context, index) {
                if (index == state.areas.length) {
                  return AreaListLastItem(
                    key: const Key('area-list-last-item'),
                    state: state,
                  );
                } else {
                  return AreaListItem(
                    key: ValueKey(state.areas.elementAt(index).hashCode),
                    area: state.areas.elementAt(index),
                  );
                }
              },
            );
          } else {
            return const Center(
              child: Text('No items'),
            );
          }
      }
    });
  }
}

/// This widget uses the current state to build a ListTile
class AreaListLastItem extends StatelessWidget {
  const AreaListLastItem({Key? key, required this.state}) : super(key: key);

  final AreasState state;

  @override
  Widget build(BuildContext context) {
    if (state.status == AreasStatus.loaded && state.hasError) {
      return const ListTile(
        title: Text('Has an error'),
      );
    } else if (state.status == AreasStatus.loading) {
      return const ListTile(
        title: CircularProgressIndicator(),
      );
    }
    return ListTile(
      title: state.nextPage == -1
          ? const Text('No more items')
          : const SizedBox(height: 24),
    );
  }
}
