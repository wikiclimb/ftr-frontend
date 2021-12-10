part of 'areas_bloc.dart';

enum AreasStatus { loading, loaded, initial }

class AreasState extends Equatable {
  const AreasState({
    required this.status,
    required this.areas,
    required this.hasError,
    required this.nextPage,
    this.query = '',
  });

  /// The current status.
  final AreasStatus status;

  /// The areas that should be displayed on the view.
  final BuiltSet<Node> areas;

  /// Flag wether the latest request resulted in a failure.
  final bool hasError;

  /// Number for the next page of data, -1 for no next page.
  final int nextPage;

  /// A query string that the bloc is providing data for in this state.
  final String query;

  @override
  List<Object> get props => [
        status,
        areas,
        hasError,
        nextPage,
        query,
      ];

  AreasState copyWith({
    AreasStatus? status,
    BuiltSet<Node>? areas,
    bool? hasError,
    int? nextPage,
    String? query,
  }) =>
      AreasState(
        status: status ?? this.status,
        areas: areas ?? this.areas,
        hasError: hasError ?? this.hasError,
        nextPage: nextPage ?? this.nextPage,
        query: query ?? this.query,
      );
}
