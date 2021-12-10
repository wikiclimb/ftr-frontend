import 'package:flutter/material.dart';

import '../../../../../core/environment/environment_config.dart';
import '../../../domain/entities/node.dart';

/// This widget creates a cover for a card with [Node] details.
///
/// The cover has a background image and a title taken from the [Node] details.
class NodeListItemCover extends StatelessWidget {
  const NodeListItemCover(
    this.node, {
    Key? key,
    this.aspectRatio = 16 / 9,
  }) : super(key: key);

  final Node node;
  final double aspectRatio;
  final placeholder = 'graphics/wikiclimb-logo-800-450.png';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (node.coverUrl != null)
              FittedBox(
                fit: BoxFit.cover,
                clipBehavior: Clip.antiAlias,
                child: FadeInImage.assetNetwork(
                  placeholder: placeholder,
                  // Scaling the placeholder fixes up jarred image rendering.
                  placeholderScale: 3,
                  image: '${EnvironmentConfig.baseImgUrl}${node.coverUrl!}',
                  imageErrorBuilder: (context, error, stackTrace) =>
                      Center(child: Image.asset(placeholder)),
                ),
              )
            else
              // Provide a placeholder box in case the image does not exist.
              Center(
                child: Image.asset(placeholder),
              ),
            Positioned(
              bottom: 8,
              left: 8,
              child: Text(
                node.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset.zero,
                      blurRadius: 3.0,
                      color: Colors.black87,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
