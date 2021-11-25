import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:wikiclimb_flutter_frontend/core/environment/environment_config.dart';
import 'package:wikiclimb_flutter_frontend/features/image/domain/entities/image.dart'
    as wkc;

/// This widget renders a list of images.
///
/// This widget renders its children as [Slivers] and provides each with an
/// instance of [Image] that contains the data they need.
class SliverImageList extends StatelessWidget {
  const SliverImageList(
    this.images, {
    Key? key,
  }) : super(key: key);

  final BuiltSet<wkc.Image> images;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => SliverImageListItem(
          image: images.elementAt(index),
        ),
        childCount: images.length,
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
