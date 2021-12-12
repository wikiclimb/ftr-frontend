import 'package:built_collection/built_collection.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/environment/environment_config.dart';
import '../../../../di.dart';
import '../../../node/domain/entities/node.dart';
import '../../../node/presentation/bloc/add_node_images/add_node_images_bloc.dart';

/// Lets the user pick images to be added to a [Node].
class AddNodeImageScreen extends StatelessWidget {
  const AddNodeImageScreen(this.node, {Key? key}) : super(key: key);

  final Node node;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add images to ${node.name}'),
      ),
      body: BlocProvider(
        create: (context) => sl<AddNodeImagesBloc>(),
        child: WkcImageSelector(node: node),
      ),
    );
  }
}

class WkcImageSelector extends StatelessWidget {
  const WkcImageSelector({
    Key? key,
    required this.node,
  }) : super(key: key);

  final Node node;
  final placeholder = EnvironmentConfig.sliverAppBarBackgroundPlaceholder;

  // Handle the result of the user selecting images or taking pictures with the
  // camera.
  // TODO test the code below providing ImagePicker as a GetIt service.
  void _handleResult(BuildContext context, BuiltList<XFile> files) {
    if (files.isNotEmpty) {
      context.read<AddNodeImagesBloc>().add(
            ImagesSelected(
              files: files,
              node: node,
            ),
          );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Action cancelled by user'),
        ),
      );
    }
  }

  // Let the user take images or select them from the file system.
  void _selectImages({
    required BuildContext context,
    required ImageSource source,
  }) async {
    final ImagePicker picker = ImagePicker();
    if (source == ImageSource.camera) {
      final XFile? result = await picker.pickImage(source: source);
      _handleResult(context, BuiltList([result]));
    } else {
      final List<XFile>? result = await picker.pickMultiImage();
      final BuiltList<XFile> files =
          result != null ? BuiltList(result) : BuiltList();
      _handleResult(context, files);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddNodeImagesBloc, AddNodeImagesState>(
      listener: (context, state) {
        if (state.status == AddNodeImagesStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('An error happened'),
            ),
          );
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: state.status == AddNodeImagesStatus.sending
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : GridView.builder(
                      key: const Key(
                          'addNodeImageScreen_previewUploaded_gridView'),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 150,
                      ),
                      itemCount: state.images.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                              clipBehavior: Clip.hardEdge,
                              color: Colors.grey.shade100,
                              child: FittedBox(
                                fit: BoxFit.cover,
                                child: CachedNetworkImage(
                                  placeholder: (_, __) =>
                                      Image.asset(placeholder),
                                  imageUrl: EnvironmentConfig.baseImgUrl +
                                      state.images.elementAt(index).fileName,
                                  errorWidget: (_, __, ___) => Center(
                                    child: Image.asset(placeholder),
                                  ),
                                ),
                              )),
                        );
                      },
                    ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    key: const Key(
                        'addNodeImageScreen_selectFromCamera_iconButton'),
                    onPressed: () {
                      _selectImages(
                          context: context, source: ImageSource.camera);
                    },
                    icon: const Icon(Icons.camera)),
                IconButton(
                    key: const Key(
                        'addNodeImageScreen_selectFromGallery_iconButton'),
                    onPressed: () {
                      _selectImages(
                          context: context, source: ImageSource.gallery);
                    },
                    icon: const Icon(Icons.folder_open)),
              ],
            ),
          ],
        );
      },
    );
  }
}
