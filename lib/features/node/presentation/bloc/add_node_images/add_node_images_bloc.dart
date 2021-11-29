import 'package:bloc/bloc.dart';
import 'package:built_collection/built_collection.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../image/domain/entities/image.dart';
import '../../../../image/domain/usecases/add_images_to_node.dart';
import '../../../domain/entities/node.dart';

part 'add_node_images_event.dart';
part 'add_node_images_state.dart';

class AddNodeImagesBloc extends Bloc<AddNodeImagesEvent, AddNodeImagesState> {
  AddNodeImagesBloc(this.addImagesToNode) : super(AddNodeImagesState()) {
    on<ImagesSelected>(_onImagesSelected);
  }

  final AddImagesToNode addImagesToNode;

  void _onImagesSelected(ImagesSelected event, Emitter emit) async {
    emit(state.copyWith(status: AddNodeImagesStatus.sending));
    final result = await addImagesToNode(Params(
      filePaths: event.files.map((f) => f.path).toList(),
      nodeId: event.node.id ?? 0,
    ));
    result.fold(
      (l) => emit(state.copyWith(status: AddNodeImagesStatus.error)),
      (imageResult) => emit(state.copyWith(
        status: AddNodeImagesStatus.success,
        images: imageResult,
      )),
    );
  }
}
