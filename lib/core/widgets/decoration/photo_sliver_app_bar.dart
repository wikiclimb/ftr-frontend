import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../environment/environment_config.dart';

/// Renders a [SliverAppBar] designed for the WikiClimb app.
///
/// The widget uses [imageUrl] as a background image and it displays [title]
/// superposed on the bottom-left corner.
class PhotoSliverAppBar extends StatelessWidget {
  const PhotoSliverAppBar({
    Key? key,
    required this.title,
    required this.imageUrl,
  }) : super(key: key);

  final String? imageUrl;
  final placeholder = EnvironmentConfig.sliverAppBarBackgroundPlaceholder;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              child: Text(
                title,
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
            )
          ],
        ),
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
        background: imageUrl != null
            ? CachedNetworkImage(
                placeholder: (_, __) => Image.asset(placeholder),
                fit: BoxFit.cover,
                imageUrl: '${EnvironmentConfig.baseImgUrl}$imageUrl',
                errorWidget: (_, __, ___) => Center(
                  child: Image.asset(placeholder),
                ),
              )
            : Center(
                key: const Key(
                    'photoSliverAppBar_backgroundImage_nullPlaceholder'),
                child: Image.asset(placeholder)),
      ),
      expandedHeight: 240,
    );
  }
}
