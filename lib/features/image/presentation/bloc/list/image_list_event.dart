part of 'image_list_bloc.dart';

abstract class ImageListEvent extends Equatable {
  const ImageListEvent();

  @override
  List<Object> get props => [];
}

class PageAdded extends ImageListEvent {
  const PageAdded(this.page);

  final Page<Image> page;

  @override
  List<Object> get props => [page];
}

class InitializationRequested extends ImageListEvent {
  const InitializationRequested({this.node});

  final Node? node;

  @override
  List<Object> get props {
    if (node != null) {
      return [node!];
    } else {
      return [];
    }
  }
}

class NextPageRequested extends ImageListEvent {}

class FailureResponse extends ImageListEvent {}
