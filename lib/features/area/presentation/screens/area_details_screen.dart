import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../di.dart';
import '../../../image/presentation/bloc/list/image_list_bloc.dart';
import '../../../image/presentation/widgets/node_sliver_image_list.dart';
import '../../../node/domain/entities/node.dart';
import '../../../node/presentation/bloc/node_edit/node_edit_bloc.dart';
import '../widgets/area_details_tab.dart';

/// Renders a widget that controls how a single area details are displayed.
///
/// This widget obtains a [Node] instance of type area and provides it to its
/// children.
class AreaDetailsScreen extends StatelessWidget {
  const AreaDetailsScreen({Key? key}) : super(key: key);

  static const String id = '/area-details';

  @override
  Widget build(BuildContext context) {
    ImageListBloc imageListBloc = sl<ImageListBloc>();
    imageListBloc.add(InitializationRequested(
      node: context.read<NodeEditBloc>().state.node,
    ));
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        bottomNavigationBar: ConvexAppBar(
          backgroundColor: Theme.of(context).primaryColor,
          items: const [
            TabItem(icon: Icons.info, title: 'Details'),
            TabItem(icon: Icons.photo, title: 'Images'),
            TabItem(icon: Icons.list, title: 'Explore'),
          ],
        ),
        body: BlocConsumer<NodeEditBloc, NodeEditState>(
          listener: (context, state) {
            switch (state.coverUpdateRequestStatus) {
              case CoverUpdateRequestStatus.loading:
                _showMessage(context, 'Updating cover image');
                break;
              case CoverUpdateRequestStatus.error:
                _showMessage(context, 'Error updating cover image');
                break;
              case CoverUpdateRequestStatus.success:
                _showMessage(context, 'Cover image updated');
                break;
              case CoverUpdateRequestStatus.initial:
                break;
            }
          },
          builder: (context, state) {
            return TabBarView(children: [
              AreaDetailsTab(
                state.node,
                key: const Key('areaDetailsScreen_areaDetailsTab'),
              ),
              BlocProvider(
                create: (context) => imageListBloc,
                child: SafeArea(
                  key: const Key('areaDetailsScreen_imageListTab_safeArea'),
                  child: CustomScrollView(
                    slivers: [
                      NodeSliverImageList(state.node),
                    ],
                  ),
                ),
              ),
              const Center(
                key: Key('areaDetailsScreen_subareasListTab_wrapper'),
                child: Text('Todo: list of children'),
              ),
            ]);
          },
        ),
      ),
    );
  }
}

void _showMessage(BuildContext ctx, String message) {
  ScaffoldMessenger.of(ctx)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(content: Text(message)),
    );
}
