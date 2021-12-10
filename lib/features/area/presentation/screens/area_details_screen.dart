import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/decoration/photo_sliver_app_bar.dart';
import '../../../../di.dart';
import '../../../authentication/presentation/bloc/authentication_bloc.dart';
import '../../../image/presentation/bloc/list/image_list_bloc.dart';
import '../../../image/presentation/widgets/node_sliver_image_list.dart';
import '../../../node/domain/entities/node.dart';
import '../../../node/presentation/bloc/node_edit/node_edit_bloc.dart';
import '../../../node/presentation/screens/edit_node_screen.dart';
import '../widgets/area_details_list.dart';

/// Renders a widget that controls how a single area details are displayed.
///
/// This widget obtains a [Node] instance of type area and provides it to its
/// children.
class AreaDetailsScreen extends StatelessWidget {
  const AreaDetailsScreen({
    Key? key,
    // required this.area,
  }) : super(key: key);

  static const String id = '/area-details';

  // final Node area;

  @override
  Widget build(BuildContext context) {
    ImageListBloc imageListBloc = sl<ImageListBloc>();
    imageListBloc.add(InitializationRequested(
      node: context.read<NodeEditBloc>().state.node,
    ));
    return Scaffold(
      floatingActionButton:
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
        if (state is AuthenticationAuthenticated) {
          return FloatingActionButton(
            key: const Key('areaDetailsScreen_editArea_fab'),
            child: const Icon(Icons.edit),
            onPressed: () {
              // Details on how to pass a bloc to a child route:
              // https://github.com/felangel/bloc/issues/502
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider<NodeEditBloc>.value(
                    value: BlocProvider.of<NodeEditBloc>(context),
                    child: const EditNodeScreen(),
                  ),
                ),
              );
            },
          );
        } else {
          return Container();
        }
      }),
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
          return CustomScrollView(
            slivers: <Widget>[
              PhotoSliverAppBar(
                title: state.node.name,
                imageUrl: state.node.coverUrl,
              ),
              AreaDetailsList(area: state.node),
              BlocProvider(
                create: (context) => imageListBloc,
                child: NodeSliverImageList(state.node),
              ),
            ],
          );
        },
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
