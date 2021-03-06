import 'package:cached_network_image/cached_network_image.dart';
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

  final double aspectRatio;
  final Node node;
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
                child: CachedNetworkImage(
                  placeholder: (_, __) => Image.asset(
                    placeholder,
                    // Scaling the placeholder fixes up jarred image rendering.
                    scale: 3,
                  ),
                  // placeholderScale: 3,
                  imageUrl: '${EnvironmentConfig.baseImgUrl}${node.coverUrl!}',
                  errorWidget: (_, __, ___) =>
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
