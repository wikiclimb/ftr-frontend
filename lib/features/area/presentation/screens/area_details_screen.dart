import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/decoration/photo_sliver_app_bar.dart';
import '../../../node/domain/entities/node.dart';
import '../widgets/area_details_list.dart';

/// Renders a widget that controls how a single area details are displayed.
///
/// This widget obtains a [Node] instance of type area and provides it to its
/// children.
class AreaDetailsScreen extends StatelessWidget {
  const AreaDetailsScreen({
    Key? key,
    required this.area,
  }) : super(key: key);

  static const String id = '/area-details';

  final Node area;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          PhotoSliverAppBar(
            title: area.name,
            imageUrl: area.coverUrl ?? '',
          ),
          AreaDetailsList(area: area),
        ],
      ),
    );
  }
}
