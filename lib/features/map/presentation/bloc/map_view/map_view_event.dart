part of 'map_view_bloc.dart';

abstract class MapViewEvent extends Equatable {
  const MapViewEvent();

  @override
  List<Object> get props => [];
}

class MapPositionChanged extends MapViewEvent {
  final MapPosition position;

  const MapPositionChanged({required this.position});
}

class PageAdded extends MapViewEvent {
  const PageAdded(this.page);

  final Page<Node> page;

  @override
  List<Object> get props => [page];
}

class FailureResponse extends MapViewEvent {}
