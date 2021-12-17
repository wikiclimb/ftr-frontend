part of 'node_list_bloc.dart';

enum NodeListStatus { loading, loaded, initial }

class NodeListState extends Equatable {
  const NodeListState({
    required this.status,
    required this.nodes,
    required this.hasError,
    required this.nextPage,
    this.query = '',
  });

  /// The current status.
  final NodeListStatus status;

  /// The nodes that should be displayed on the view.
  final BuiltSet<Node> nodes;

  /// Flag wether the latest request resulted in a failure.
  final bool hasError;

  /// Number for the next page of data, -1 for no next page.
  final int nextPage;

  /// A query string that the bloc is providing data for in this state.
  final String query;

  @override
  List<Object> get props => [
        status,
        nodes,
        hasError,
        nextPage,
        query,
      ];

  NodeListState copyWith({
    NodeListStatus? status,
    BuiltSet<Node>? nodes,
    bool? hasError,
    int? nextPage,
    String? query,
  }) =>
      NodeListState(
        status: status ?? this.status,
        nodes: nodes ?? this.nodes,
        hasError: hasError ?? this.hasError,
        nextPage: nextPage ?? this.nextPage,
        query: query ?? this.query,
      );
}
