import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/environment/environment_config.dart';
import '../../../node/presentation/bloc/node_edit/node_edit_bloc.dart';
import '../../domain/entities/image.dart' as wkc;

/// This widget is in charge of rendering a [Node] [Image] in a [Sliver] list.
///
/// The widget is in charge of displaying an image it gets in it's constructor
/// and sending events to the bloc in response to user interaction.
class SliverImageListItem extends StatelessWidget {
  const SliverImageListItem({
    Key? key,
    required this.image,
  }) : super(key: key);

  final wkc.Image image;
  final placeholder = EnvironmentConfig.sliverAppBarBackgroundPlaceholder;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: [
          CachedNetworkImage(
            placeholder: (_, __) => Image.asset(
              placeholder,
              scale: 3,
            ),
            imageUrl: EnvironmentConfig.baseImgUrl + image.fileName,
            errorWidget: (_, __, ___) => Center(
              child: Image.asset(placeholder),
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onLongPress: () {
                  _requestCoverUpdate(context, image);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Display a confirmation dialog and, post a [CoverUpdateRequested] event.
void _requestCoverUpdate(BuildContext context, wkc.Image image) {
  showDialog<String>(
    context: context,
    builder: (BuildContext ctx) => AlertDialog(
      title: const Text('Update cover'),
      content: const Text('Use this image as the cover'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(ctx, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            context
                .read<NodeEditBloc>()
                .add(NodeCoverUpdateRequested(image.fileName));
            Navigator.pop(ctx, 'Ok');
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
