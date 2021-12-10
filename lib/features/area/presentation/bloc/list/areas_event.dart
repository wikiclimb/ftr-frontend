part of 'areas_bloc.dart';

abstract class AreasEvent extends Equatable {
  const AreasEvent();

  @override
  List<Object> get props => [];
}

class PageAdded extends AreasEvent {
  const PageAdded(this.page);

  final Page<Node> page;

  @override
  List<Object> get props => [page];
}

class NextPageRequested extends AreasEvent {}

class FailureResponse extends AreasEvent {}

class SearchQueryUpdated extends AreasEvent {
  const SearchQueryUpdated({required this.query});

  final String query;

  @override
  List<Object> get props => [query];
}
