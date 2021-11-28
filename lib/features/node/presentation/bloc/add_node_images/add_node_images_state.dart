part of 'add_node_images_bloc.dart';

enum AddNodeImagesStatus { initial, sending, success, error }

class AddNodeImagesState extends Equatable {
  AddNodeImagesState({
    BuiltList<XFile>? files,
    BuiltList<Image>? images,
    String? name,
    String? description,
    AddNodeImagesStatus? status,
  })  : _files = files ?? BuiltList(),
        _images = images ?? BuiltList(),
        _name = name ?? '',
        _description = description ?? '',
        _status = status ?? AddNodeImagesStatus.initial;

  final String _description;
  final BuiltList<XFile> _files;
  final BuiltList<Image> _images;
  final String _name;
  final AddNodeImagesStatus _status;

  @override
  List<Object> get props => [_name, _description, _files, _images, _status];

  AddNodeImagesStatus get status => _status;

  BuiltList<Image> get images => _images;

  AddNodeImagesState copyWith({
    BuiltList<XFile>? files,
    BuiltList<Image>? images,
    String? name,
    String? description,
    AddNodeImagesStatus? status,
  }) {
    return AddNodeImagesState(
      files: files ?? _files,
      images: images ?? _images,
      name: name ?? _name,
      description: description ?? _description,
      status: status ?? _status,
    );
  }
}
