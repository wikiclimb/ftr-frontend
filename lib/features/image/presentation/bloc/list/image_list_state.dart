part of 'image_list_bloc.dart';

enum ImageListStatus { loading, loaded, initial }

class ImageListState extends Equatable {
  const ImageListState({
    required this.status,
    required this.images,
    required this.hasError,
    required this.nextPage,
    this.node,
  });

  /// The current status.
  final ImageListStatus status;

  /// The areas that should be displayed on the view.
  final BuiltSet<Image> images;

  /// Flag wether the latest request resulted in a failure.
  final bool hasError;

  /// Number for the next page of data, -1 for no next page.
  final int nextPage;

  final Node? node;

  ImageListState copyWith({
    ImageListStatus? status,
    BuiltSet<Image>? images,
    bool? hasError,
    int? nextPage,
    Node? node,
  }) {
    return ImageListState(
      status: status ?? this.status,
      images: images ?? this.images,
      hasError: hasError ?? this.hasError,
      nextPage: nextPage ?? this.nextPage,
      node: node ?? this.node,
    );
  }

  @override
  List<Object?> get props => [
        status,
        images,
        hasError,
        nextPage,
        node,
      ];
}
