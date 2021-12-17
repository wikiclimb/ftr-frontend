import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/decoration/photo_sliver_app_bar.dart';
import '../../../authentication/presentation/bloc/authentication_bloc.dart';
import '../../../node/domain/entities/node.dart';
import '../../../node/presentation/bloc/node_edit/node_edit_bloc.dart';
import '../../../node/presentation/screens/edit_node_screen.dart';
import '../../../node/presentation/widgets/node_details/node_details_list.dart';

/// This widget shows details about a [Node] of type area.
///
/// The widget is in charge of showing details about a node that it obtains as a
/// constructor parameter. It also handles navigation to the edit node screen.
class AreaDetailsTab extends StatelessWidget {
  const AreaDetailsTab(this.node, {Key? key}) : super(key: key);

  final Node node;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          slivers: <Widget>[
            PhotoSliverAppBar(
              title: node.name,
              imageUrl: node.coverUrl,
            ),
            NodeDetailsList(node),
          ],
        ),
        BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
          if (state is AuthenticationAuthenticated) {
            return Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton(
                heroTag: 'areaDetailsScreen_editArea_fab',
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
              ),
            );
          } else {
            return Container();
          }
        }),
      ],
    );
  }
}
