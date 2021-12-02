import 'package:bloc/bloc.dart';
import 'package:built_collection/built_collection.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../../../../core/utils/locator.dart';
import '../../../domain/entities/inputs/inputs.dart';
import '../../../domain/entities/node.dart';
import '../../../domain/usecases/edit_node.dart';

part 'node_edit_event.dart';
part 'node_edit_state.dart';

/// Handle node edit form status.
class NodeEditBloc extends Bloc<NodeEditEvent, NodeEditState> {
  NodeEditBloc({
    required this.editNode,
    required this.locator,
  }) : super(const NodeEditState()) {
    on<NodeDescriptionChanged>(_onNodeDescriptionChanged);
    on<NodeEditInitialize>(_onNodeEditInitialize);
    on<NodeLatitudeChanged>(_onNodeLatitudeChanged);
    on<NodeLongitudeChanged>(_onNodeLongitudeChanged);
    on<NodeNameChanged>(_onNodeNameChanged);
    on<NodeSubmissionRequested>(_onNodeSubmissionRequested);
    on<NodeGeolocationRequested>(_onNodeGeolocationRequested);
  }

  final EditNode editNode;
  final Locator locator;

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
    final latitude = NodeLatitude.pure(_node.lat?.toString() ?? '');
    final longitude = NodeLongitude.pure(_node.lng?.toString() ?? '');

    emit(
      state.copyWith(
        type: _node.type,
        name: name,
        description: description,
        latitude: latitude,
        longitude: longitude,
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

  void _onNodeLatitudeChanged(NodeLatitudeChanged event, Emitter emit) {
    final latitude = NodeLatitude.dirty(event.latitude);
    if (latitude.valid) {
      _node = _node.rebuild((n) => n..lat = double.tryParse(event.latitude));
    }
    emit(state.copyWith(
      latitude: latitude,
      status: _validate(latitude: latitude),
    ));
  }

  void _onNodeLongitudeChanged(NodeLongitudeChanged event, Emitter emit) {
    final longitude = NodeLongitude.dirty(event.longitude);
    if (longitude.valid) {
      _node = _node.rebuild((n) => n..lng = double.tryParse(event.longitude));
    }
    emit(state.copyWith(
      longitude: longitude,
      status: _validate(longitude: longitude),
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

  void _onNodeGeolocationRequested(
      NodeGeolocationRequested event, Emitter emit) async {
    emit(state.copyWith(glStatus: GeolocationRequestStatus.requested));
    try {
      final position = await locator.determinePosition();
      _node = _node.rebuild((n) => n
        ..lng = position.longitude
        ..lat = position.latitude);
      final longitude = NodeLongitude.dirty(position.longitude.toString());
      final latitude = NodeLatitude.dirty(position.latitude.toString());
      emit(state.copyWith(
        glStatus: GeolocationRequestStatus.success,
        longitude: longitude,
        latitude: latitude,
        status: _validate(),
      ));
      // Restore the state
      await Future.delayed(const Duration(milliseconds: 300));
      emit(state.copyWith(glStatus: GeolocationRequestStatus.done));
    } catch (_) {
      emit(state.copyWith(glStatus: GeolocationRequestStatus.failure));
      // Restore the state
      await Future.delayed(const Duration(milliseconds: 300));
      emit(state.copyWith(glStatus: GeolocationRequestStatus.initial));
    }
  }

  // Extract the validation logic to avoid copying property names
  // in each validation call.
  FormzStatus _validate({
    NodeName? name,
    NodeDescription? description,
    NodeLatitude? latitude,
    NodeLongitude? longitude,
  }) {
    // Some fields are optional, name and description are required.
    final fieldBuilder = BuiltSet<FormzInput>().toBuilder();
    fieldBuilder.add(name ?? state.name);
    fieldBuilder.add(description ?? state.description);
    if (latitude != null || !state.latitude.pure) {
      fieldBuilder.add(latitude ?? state.latitude);
    }
    if (longitude != null || !state.longitude.pure) {
      fieldBuilder.add(longitude ?? state.longitude);
    }
    return Formz.validate(fieldBuilder.build().toList());
  }
}
