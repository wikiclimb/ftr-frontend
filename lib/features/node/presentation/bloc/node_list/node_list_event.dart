part of 'node_list_bloc.dart';

abstract class NodeListEvent extends Equatable {
  const NodeListEvent();

  @override
  List<Object> get props => [];
}

class PageAdded extends NodeListEvent {
  const PageAdded(this.page);

  final Page<Node> page;

  @override
  List<Object> get props => [page];
}

class NextPageRequested extends NodeListEvent {}

class FailureResponse extends NodeListEvent {}

class SearchQueryUpdated extends NodeListEvent {
  const SearchQueryUpdated({required this.query});

  final String query;

  @override
  List<Object> get props => [query];
}
