import 'package:flutter/material.dart';
import 'package:wikiclimb_flutter_frontend/core/widgets/decoration/star_rating_widget.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/node.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/widgets/node_breadcrumbs.dart';

/// Renders a list of widgets containing details about an [Node] of type area.
///
/// This widget renders its children in a [SliverList] which makes it suitable
/// to use as a sliver inside a [Scrollable] widget like a [CustomScrollView].
class AreaDetailsList extends StatelessWidget {
  const AreaDetailsList({
    Key? key,
    required this.area,
  }) : super(key: key);

  final Node area;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          const SizedBox(height: 8),
          if (area.breadcrumbs != null && area.breadcrumbs!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: NodeBreadcrumbs(area),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: StarRatingWidget(
              rating: area.rating ?? 0,
              ratingsCount: area.ratingsCount ?? 0,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  area.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                const Text('7a+'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (area.description != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(area.description ?? ''),
            ),
        ],
      ),
    );
  }
}
