import 'package:flutter/material.dart';

import '../../../node/domain/entities/node.dart';

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
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => Container(
          color: Colors.blue,
          height: 100,
          child: Center(
            child: Text('item $index'),
          ),
        ),
        childCount: 10,
      ),
    );
  }
}
