part of 'node_details_bloc.dart';

abstract class NodeDetailsState extends Equatable {
  const NodeDetailsState();

  @override
  List<Object> get props => [];
}

class NodeDetailsInitial extends NodeDetailsState {}
