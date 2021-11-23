import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../../domain/entities/inputs/inputs.dart';
import '../../../domain/entities/node.dart';
import '../../../domain/usecases/edit_node.dart';

part 'node_edit_event.dart';
part 'node_edit_state.dart';

/// Handle node edit form status.
class NodeEditBloc extends Bloc<NodeEditEvent, NodeEditState> {
  NodeEditBloc(this.editNode) : super(const NodeEditState()) {
    on<NodeDescriptionChanged>(_onNodeDescriptionChanged);
    on<NodeEditInitialize>(_onNodeEditInitialize);
    on<NodeNameChanged>(_onNodeNameChanged);
    on<NodeSubmissionRequested>(_onNodeSubmissionRequested);
  }

  final EditNode editNode;
  late Node _node;

  void _onNodeEditInitialize(
    NodeEditInitialize event,
    emit,
  ) {
    // Assign the node to the bloc.
    _node = event.node;
    // Pre-fill the form with the values found on the [Node].
    final name = NodeName.pure(_node.name);
    final description = NodeDescription.pure(_node.description ?? '');
    emit(
      state.copyWith(
        type: _node.type,
        name: name,
        description: description,
      ),
    );
  }

  void _onNodeNameChanged(NodeNameChanged event, Emitter emit) {
    _node = _node.rebuild((n) => n..name = event.name);
    final name = NodeName.dirty(event.name);
    emit(state.copyWith(
      name: name,
      status: _validate(name: name),
    ));
  }

  void _onNodeDescriptionChanged(NodeDescriptionChanged event, Emitter emit) {
    _node = _node.rebuild((n) => n..description = event.description);
    final description = NodeDescription.dirty(event.description);
    emit(state.copyWith(
      description: description,
      status: _validate(description: description),
    ));
  }

  void _onNodeSubmissionRequested(
    NodeSubmissionRequested event,
    Emitter emit,
  ) async {
    emit(state.copyWith(
      status: FormzStatus.submissionInProgress,
    ));
    final result = await editNode(_node);
    result.fold((failure) {
      emit(state.copyWith(
        status: FormzStatus.submissionFailure,
      ));
    }, (resultNode) {
      emit(state.copyWith(
        status: FormzStatus.submissionSuccess,
        node: resultNode,
      ));
    });
  }

  // Extract the validation logic to avoid copying property names
  // in each validation call.
  FormzStatus _validate({
    NodeName? name,
    NodeDescription? description,
  }) {
    return Formz.validate([
      name ?? state.name,
      description ?? state.description,
    ]);
  }
}
