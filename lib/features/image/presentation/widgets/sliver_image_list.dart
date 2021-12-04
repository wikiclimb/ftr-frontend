import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../authentication/presentation/bloc/authentication_bloc.dart';
import '../../../node/domain/entities/node.dart';
import '../../domain/entities/image.dart' as wkc;
import '../screens/add_node_image_screen.dart';
import 'sliver_image_list_item.dart';

/// This widget renders a list of images.
///
/// This widget renders its children as [Slivers] and provides each with an
/// instance of [Image] that contains the data they need.
class SliverImageList extends StatelessWidget {
  const SliverImageList(
    this.images, {
    required this.node,
    Key? key,
  }) : super(key: key);

  final BuiltSet<wkc.Image> images;
  final Node node;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == 0) {
            return SliverImageListAddImagesButton(node: node);
          } else {
            return SliverImageListItem(
              image: images.elementAt(index - 1),
            );
          }
        },
        childCount: images.length + 1,
      ),
    );
  }
}

class SliverImageListAddImagesButton extends StatelessWidget {
  const SliverImageListAddImagesButton({
    Key? key,
    required this.node,
  }) : super(key: key);

  final Node node;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationAuthenticated) {
            return ElevatedButton.icon(
              key: const Key('sliverImageList_addNodeImages_elevatedButton'),
              icon: const Icon(Icons.add_a_photo),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddNodeImageScreen(node),
                  ),
                );
              },
              label: const Text('Add Photos'),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
