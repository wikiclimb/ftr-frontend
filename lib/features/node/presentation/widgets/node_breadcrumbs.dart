import 'package:flutter/material.dart';

import '../../domain/entities/node.dart';

/// A list of breadcrumbs that display the name of this [Node]'s ancestors.
///
/// The [height] of the widget and the [separator] element and [separatorColor]
/// and [textColor] used can be configured using constructor parameters.
class NodeBreadcrumbs extends StatelessWidget {
  const NodeBreadcrumbs(
    this.area, {
    Key? key,
    this.height = 24,
    this.textColor = Colors.blueAccent,
    this.separator = '»',
    this.separatorColor = Colors.redAccent,
  }) : super(key: key);

  final Node area;
  final double height;
  final Color textColor;
  final String separator;
  final Color separatorColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Align(
        alignment: Alignment.centerLeft,
        child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: area.breadcrumbs?.length ?? 0,
          itemBuilder: (context, index) {
            return Text(
              area.breadcrumbs?[index] ?? '',
              style: TextStyle(
                fontSize: 13,
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 2.0,
              ),
              child: Text(separator,
                  style: TextStyle(
                    color: separatorColor,
                  )),
            );
          },
        ),
      ),
    );
  }
}
