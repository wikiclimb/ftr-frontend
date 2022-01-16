import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/widgets/navigation/main_drawer.dart';
import '../../../../di.dart';
import '../../../authentication/presentation/bloc/authentication_bloc.dart';
import '../../../node/presentation/bloc/node_list/node_list_bloc.dart';
import '../../../node/presentation/widgets/list/node_list.dart';
import '../../../node/presentation/widgets/list/node_list_item.dart';
import '../../../node/presentation/widgets/search/node_search_bar.dart';

/// This screen shows a featured list of [Node] and a greeting.
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String id = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(currentRoute: HomeScreen.id),
      body: BlocProvider(
        create: (context) => sl<NodeListBloc>(),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomScrollView(
              slivers: <Widget>[
                BlocBuilder<NodeListBloc, NodeListState>(
                  builder: (context, state) {
                    return state.query.isEmpty
                        ? SliverToBoxAdapter(
                            child: SizedBox(
                              height: 360,
                              child: Column(
                                children: [
                                  const SizedBox(height: 110),
                                  const SizedBox(
                                    height: 200,
                                    child: Image(
                                      image: AssetImage(
                                          'graphics/wikiclimb-logo.png'),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  BlocBuilder<AuthenticationBloc,
                                      AuthenticationState>(
                                    builder: (context, state) {
                                      // final String message = state
                                      //         is AuthenticationAuthenticated
                                      //     ? 'Hello ${state.authenticationData.username}'
                                      //     : 'Hello guest';
                                      final message =
                                          AppLocalizations.of(context)!
                                              .helloWorld;
                                      return Text(message);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const SliverToBoxAdapter(
                            child: SizedBox(height: 110));
                  },
                ),
                BlocBuilder<NodeListBloc, NodeListState>(
                  builder: (context, state) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index == state.nodes.length) {
                            return NodeListLastItem(
                              key: const Key('nodeList_nodeListLastItem'),
                              state: state,
                            );
                          } else {
                            return NodeListItem(
                              key: ValueKey(
                                  state.nodes.elementAt(index).hashCode),
                              node: state.nodes.elementAt(index),
                            );
                          }
                        },
                        childCount: state.nodes.length + 1,
                      ),
                    );
                  },
                ),
              ],
            ),
            const NodeSearchBar(),
          ],
        ),
      ),
    );
  }
}
