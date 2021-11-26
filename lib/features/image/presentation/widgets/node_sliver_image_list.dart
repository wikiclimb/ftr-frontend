import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../node/domain/entities/node.dart';
import '../bloc/list/image_list_bloc.dart';
import 'sliver_image_list.dart';

/// This widget takes in a [Node] parent and loads a list of related images.
///
/// The widget is in charge of loading the images from the server based on
/// the given [Node] and rendering them wrapped in a [Sliver].
class NodeSliverImageList extends StatelessWidget {
  const NodeSliverImageList(
    this.node, {
    Key? key,
  }) : super(key: key);

  final Node node;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageListBloc, ImageListState>(
      builder: (context, state) {
        const keyStart = 'nodeSliverImageList_statusNotification_';
        if (state.status == ImageListStatus.loaded) {
          if (state.hasError) {
            return const NodeSliverImageListStatusNotification(
              key: Key('${keyStart}error'),
              child: Text('Error fetching images.'),
            );
          } else {
            return SliverImageList(
              state.images,
              key: const Key('${keyStart}imageList'),
              node: node,
            );
          }
        }
        return const NodeSliverImageListStatusNotification(
          key: Key('${keyStart}loading'),
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

/// Display a [Sliver] widget with information about the current status.
class NodeSliverImageListStatusNotification extends StatelessWidget {
  const NodeSliverImageListStatusNotification({required this.child, Key? key})
      : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Card(
        child: SizedBox(
          height: 100,
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}
