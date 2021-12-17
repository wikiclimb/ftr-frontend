import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../di.dart';
import '../../../domain/entities/node.dart';
import '../../bloc/node_edit/node_edit_bloc.dart';
import '../../screens/node_details_screen.dart';
import '../list_item/node_list_item_cover.dart';

/// Renders a map popup with information about a [Node].
///
/// This widget is intended to be used as a popup together with [FlutterMap] to
/// display information about a given [Node] when the user taps on the [Marker]
/// that represents its position on the map.
class NodePopup extends StatelessWidget {
  const NodePopup(this.node, {Key? key}) : super(key: key);

  final Node node;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      width: 300,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => sl<NodeEditBloc>(param1: node),
                child: const NodeDetailsScreen(),
              ),
            ),
          );
        },
        child: Card(
          child: Column(
            children: [
              NodeListItemCover(node),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  node.description ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
