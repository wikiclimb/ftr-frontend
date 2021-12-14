import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/area/presentation/screens/add_area_screen.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/presentation/bloc/authentication_bloc.dart';

import '../../../../di.dart';
import '../../../node/domain/entities/node.dart';
import '../bloc/list/areas_bloc.dart';
import 'area_list.dart';
import 'area_search_bar.dart';

/// Renders a list of first level children of type area of a given [Node].
///
/// This widget is similar to the [AreaListScreen] but it restricts the children
/// it displays to the first level children of a [Node] that it receives as a
/// constructor parameter. This widget is intended to help the user navigate
/// nodes going down one level at a time.
/// In the future it is possible that this screen could display multiple levels
/// of descendants using the search function to sort through them.
class AreaChildrenTab extends StatelessWidget {
  const AreaChildrenTab({Key? key, required this.parentNode}) : super(key: key);

  final Node parentNode;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AreasBloc>(
      create: (_) => sl<AreasBloc>(param1: parentNode),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const AreaList(),
          const AreaSearchBar(),
          Positioned(
            bottom: 24,
            right: 16,
            child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                if (state is AuthenticationAuthenticated) {
                  return FloatingActionButton(
                    heroTag: 'areaDetailsScreen_areaChildrenTab_addChild_fab',
                    key: const Key(
                        'areaDetailsScreen_areaChildrenTab_addChild_fab'),
                    child: const Icon(Icons.add),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddAreaScreen(
                            parent: parentNode,
                          ),
                        ),
                      );
                    },
                  );
                }
                return Container();
              },
            ),
          )
        ],
      ),
    );
  }
}
