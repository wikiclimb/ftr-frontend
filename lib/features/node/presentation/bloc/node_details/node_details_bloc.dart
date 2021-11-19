import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'node_details_event.dart';
part 'node_details_state.dart';

class NodeDetailsBloc extends Bloc<NodeDetailsEvent, NodeDetailsState> {
  NodeDetailsBloc() : super(NodeDetailsInitial()) {
    on<NodeDetailsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
