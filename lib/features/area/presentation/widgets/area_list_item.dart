import 'package:flutter/material.dart';

import '../../../node/domain/entities/node.dart';
import '../../../node/presentation/widgets/list_item/node_list_item_cover.dart';
import '../screens/area_details_screen.dart';

/// Renders a widget that displays area information inside a list.
///
/// The information is rendered inside a tappable material [Card].
/// This widget will try to render the item's cover image and name in a
/// prominent placement, with detailed information relegated to a secondary
/// placement. It is meant to give a quick overview of an item.
class AreaListItem extends StatelessWidget {
  const AreaListItem({Key? key, required this.area}) : super(key: key);

  final Node area;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AreaDetailsScreen(area: area),
          ),
        );
      },
      child: Card(
        child: Column(
          children: [
            NodeListItemCover(area),
            const SizedBox(height: 8),
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
                    itemCount: area.breadcrumbs?.length ?? 0,
                    itemBuilder: (context, index) {
                      return Text(
                        area.breadcrumbs?[index] ?? '',
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
                  area.description ?? '',
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
