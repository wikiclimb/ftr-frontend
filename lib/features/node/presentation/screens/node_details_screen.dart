import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/widgets/tabs/node_children_tab.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/widgets/tabs/node_details_tab.dart';

import '../../../../di.dart';
import '../../../image/presentation/bloc/list/image_list_bloc.dart';
import '../../../image/presentation/widgets/node_sliver_image_list.dart';
import '../../../node/domain/entities/node.dart';
import '../../../node/presentation/bloc/node_edit/node_edit_bloc.dart';

/// Renders a widget that controls how a single node details are displayed.
///
/// This widget obtains a [Node] instance of type node and provides it to its
/// children.
class NodeDetailsScreen extends StatelessWidget {
  const NodeDetailsScreen({Key? key}) : super(key: key);

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
              NodeDetailsTab(
                state.node,
                key: const Key('nodeDetailsScreen_nodeDetailsTab'),
              ),
              BlocProvider(
                create: (context) => imageListBloc,
                child: SafeArea(
                  key: const Key('nodeDetailsScreen_imageListTab_safeArea'),
                  child: CustomScrollView(
                    slivers: [
                      NodeSliverImageList(state.node),
                    ],
                  ),
                ),
              ),
              NodeChildrenTab(parentNode: state.node),
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
