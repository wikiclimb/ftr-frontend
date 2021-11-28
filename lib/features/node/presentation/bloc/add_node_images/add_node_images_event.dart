part of 'add_node_images_bloc.dart';

abstract class AddNodeImagesEvent extends Equatable {
  const AddNodeImagesEvent();

  @override
  List<Object> get props => [];
}

/// The user has selected images and expects them to be added to the [Node].
class ImagesSelected extends AddNodeImagesEvent {
  const ImagesSelected({required this.files, required this.node});

  final BuiltList<XFile> files;
  final Node node;
}
