part of 'add_node_images_bloc.dart';

abstract class AddNodeImagesEvent extends Equatable {}

/// The user has selected images and expects them to be added to the [Node].
class ImagesSelected extends AddNodeImagesEvent {
  ImagesSelected({required this.files, required this.node});

  final BuiltList<XFile> files;
  final Node node;

  @override
  List<Object> get props => [node, files];
}
