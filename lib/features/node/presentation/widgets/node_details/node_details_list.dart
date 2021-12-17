import 'package:flutter/material.dart';

import '../../../../../core/widgets/decoration/star_rating_widget.dart';
import '../../../domain/entities/node.dart';
import '../node_breadcrumbs.dart';

/// Renders a list of widgets containing details for a [Node].
///
/// This widget renders its children in a [SliverList] which makes it suitable
/// to use as a sliver inside a [Scrollable] widget like a [CustomScrollView].
class NodeDetailsList extends StatelessWidget {
  const NodeDetailsList(this.node, {Key? key}) : super(key: key);

  final Node node;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          const SizedBox(height: 8),
          if (node.breadcrumbs != null && node.breadcrumbs!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: NodeBreadcrumbs(node),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: StarRatingWidget(
              rating: node.rating ?? 0,
              ratingsCount: node.ratingsCount ?? 0,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  node.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (node.type == 2)
                  const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text(
                      '7a+',
                      key: Key('nodeDetailsList_routeGrade_Text'),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (node.description != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(node.description ?? ''),
            ),
        ],
      ),
    );
  }
}
