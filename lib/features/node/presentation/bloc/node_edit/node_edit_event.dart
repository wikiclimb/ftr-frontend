part of 'node_edit_bloc.dart';

abstract class NodeEditEvent extends Equatable {
  const NodeEditEvent();

  @override
  List<Object> get props => [];
}

class NodeEditInitialize extends NodeEditEvent {
  const NodeEditInitialize(this.node);

  final Node node;

  @override
  List<Object> get props => [node];
}

class NodeNameChanged extends NodeEditEvent {
  const NodeNameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class NodeDescriptionChanged extends NodeEditEvent {
  const NodeDescriptionChanged(this.description);

  final String description;

  @override
  List<Object> get props => [description];
}

class NodeSubmissionRequested extends NodeEditEvent {}
