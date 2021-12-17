import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../di.dart';
import '../../../domain/entities/node.dart';
import '../../bloc/node_edit/node_edit_bloc.dart';
import '../../screens/node_details_screen.dart';
import '../list_item/node_list_item_cover.dart';

/// Renders a widget that displays [Node] information inside a list.
///
/// The information is rendered inside a tappable material [Card].
/// This widget will try to render the item's cover image and name in a
/// prominent placement, with detailed information relegated to a secondary
/// placement. It is meant to give a quick overview of an item.
class NodeListItem extends StatelessWidget {
  const NodeListItem({Key? key, required this.node}) : super(key: key);

  final Node node;

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
            if (node.breadcrumbs != null && node.breadcrumbs!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                child: SizedBox(
                  height: 24,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: node.breadcrumbs?.length ?? 0,
                      itemBuilder: (context, index) {
                        return Text(
                          node.breadcrumbs?[index] ?? '',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 2.0,
                          ),
                          child: Text('»',
                              style: TextStyle(
                                color: Colors.redAccent,
                              )),
                        );
                      },
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  node.description ?? '',
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
