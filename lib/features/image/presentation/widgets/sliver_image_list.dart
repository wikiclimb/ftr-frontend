import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';

import '../../../../core/environment/environment_config.dart';
import '../../../node/domain/entities/node.dart';
import '../../domain/entities/image.dart' as wkc;
import '../screens/add_node_image_screen.dart';

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
      child: ElevatedButton.icon(
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
      ),
    );
  }
}

class SliverImageListItem extends StatelessWidget {
  const SliverImageListItem({
    Key? key,
    required this.image,
  }) : super(key: key);

  final wkc.Image image;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: FadeInImage.assetNetwork(
      placeholder: EnvironmentConfig.sliverAppBarBackgroundPlaceholder,
      image: EnvironmentConfig.baseImgUrl + image.fileName,
      imageErrorBuilder: (context, error, stackTrace) => Center(
        child: Image.asset(EnvironmentConfig.sliverAppBarBackgroundPlaceholder),
      ),
    ));
  }
}
