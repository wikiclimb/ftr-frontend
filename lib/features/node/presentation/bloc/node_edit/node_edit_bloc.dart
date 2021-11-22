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

  void _onNodeEditInitialize(
    NodeEditInitialize event,
    emit,
  ) {
    // Pre-fill the form with the values found on the [Node].
    final node = event.node;
    final name = NodeName.pure(node.name);
    final description = NodeDescription.pure(node.description ?? '');
    emit(
      state.copyWith(
        type: node.type,
        name: name,
        description: description,
      ),
    );
  }

  void _onNodeNameChanged(event, emit) {
    final name = NodeName.dirty(event.name);
    emit(state.copyWith(
      name: name,
      status: _validate(name: name),
    ));
  }

  void _onNodeDescriptionChanged(event, emit) {
    final description = NodeDescription.dirty(event.description);
    emit(state.copyWith(
      description: description,
      status: _validate(description: description),
    ));
  }

  void _onNodeSubmissionRequested(event, emit) async {
    emit(state.copyWith(
      status: FormzStatus.submissionInProgress,
    ));
    final node = Node((n) => n
      ..type = state.type
      ..name = state.name.value
      ..description = state.description.value);
    final result = await editNode(node);
    result.fold((failure) {
      emit(state.copyWith(
        status: FormzStatus.submissionFailure,
      ));
    }, (resultNode) {
      emit(state.copyWith(
        status: FormzStatus.submissionSuccess,
      ));
    });
    // TODO navigate to node details screen.
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
