import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/image/presentation/widgets/node_sliver_image_list.dart';

import '../../../../core/widgets/decoration/photo_sliver_app_bar.dart';
import '../../../authentication/presentation/bloc/authentication_bloc.dart';
import '../../../node/domain/entities/node.dart';
import '../../../node/presentation/screens/edit_node_screen.dart';
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
      floatingActionButton:
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
        if (state is AuthenticationAuthenticated) {
          return FloatingActionButton(
            key: const Key('areaDetailsScreen_editArea_fab'),
            child: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditNodeScreen(area),
                ),
              );
            },
          );
        } else {
          return Container();
        }
      }),
      body: CustomScrollView(
        slivers: <Widget>[
          PhotoSliverAppBar(
            title: area.name,
            imageUrl: area.coverUrl,
          ),
          AreaDetailsList(area: area),
          NodeSliverImageList(area),
        ],
      ),
    );
  }
}
