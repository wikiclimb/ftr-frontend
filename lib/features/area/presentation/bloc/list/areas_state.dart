part of 'areas_bloc.dart';

enum AreasStatus { loading, loaded, initial }

class AreasState extends Equatable {
  const AreasState({
    required this.status,
    required this.areas,
    required this.hasError,
    required this.nextPage,
  });

  /// The current status.
  final AreasStatus status;

  /// The areas that should be displayed on the view.
  final BuiltSet areas;

  /// Flag wether the latest request resulted in a failure.
  final bool hasError;

  /// Number for the next page of data, -1 for no next page.
  final int nextPage;

  @override
  List<Object> get props => [
        status,
        areas,
        hasError,
        nextPage,
      ];
}
