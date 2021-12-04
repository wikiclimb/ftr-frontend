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
    required Node node,
  }) : super(NodeEditState(
          node: node,
          type: node.type,
          name: NodeName.pure(node.name),
          description: NodeDescription.pure(node.description ?? ''),
          latitude: NodeLatitude.pure(node.lat?.toString() ?? ''),
          longitude: NodeLongitude.pure(node.lng?.toString() ?? ''),
        )) {
    on<NodeDescriptionChanged>(_onNodeDescriptionChanged);
    on<NodeLatitudeChanged>(_onNodeLatitudeChanged);
    on<NodeLongitudeChanged>(_onNodeLongitudeChanged);
    on<NodeNameChanged>(_onNodeNameChanged);
    on<NodeSubmissionRequested>(_onNodeSubmissionRequested);
    on<NodeGeolocationRequested>(_onNodeGeolocationRequested);
    on<NodeCoverUpdateRequested>(_onNodeCoverUpdateRequested);
  }

  final EditNode editNode;
  final Locator locator;

  void _onNodeNameChanged(NodeNameChanged event, Emitter emit) {
    final name = NodeName.dirty(event.name);
    emit(state.copyWith(
      name: name,
      node: state.node.rebuild((n) => n..name = event.name),
      status: _validate(name: name),
    ));
  }

  void _onNodeLatitudeChanged(NodeLatitudeChanged event, Emitter emit) {
    final latitude = NodeLatitude.dirty(event.latitude);
    emit(state.copyWith(
      latitude: latitude,
      node: latitude.valid
          ? state.node.rebuild((n) => n..lat = double.tryParse(event.latitude))
          : null,
      status: _validate(latitude: latitude),
    ));
  }

  void _onNodeLongitudeChanged(NodeLongitudeChanged event, Emitter emit) {
    final longitude = NodeLongitude.dirty(event.longitude);
    emit(state.copyWith(
      longitude: longitude,
      node: longitude.valid
          ? state.node.rebuild((n) => n..lng = double.tryParse(event.longitude))
          : null,
      status: _validate(longitude: longitude),
    ));
  }

  void _onNodeDescriptionChanged(NodeDescriptionChanged event, Emitter emit) {
    final description = NodeDescription.dirty(event.description);
    emit(state.copyWith(
      description: description,
      node: state.node.rebuild((n) => n..description = event.description),
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
    final result = await editNode(state.node);
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

  void _onNodeCoverUpdateRequested(
      NodeCoverUpdateRequested event, Emitter emit) async {
    emit(
      state.copyWith(
          coverUpdateRequestStatus: CoverUpdateRequestStatus.loading),
    );
    // Try to update the node with the updated cover url
    final result = await editNode(
      state.node.rebuild((n) => n..coverUrl = event.fileName),
    );
    result.fold((failure) {
      emit(state.copyWith(
        coverUpdateRequestStatus: CoverUpdateRequestStatus.error,
      ));
    }, (resultNode) {
      emit(state.copyWith(
        coverUpdateRequestStatus: CoverUpdateRequestStatus.success,
        node: resultNode,
      ));
    });
  }

  void _onNodeGeolocationRequested(
      NodeGeolocationRequested event, Emitter emit) async {
    emit(state.copyWith(glStatus: GeolocationRequestStatus.requested));
    try {
      final position = await locator.determinePosition();
      final longitude = NodeLongitude.dirty(position.longitude.toString());
      final latitude = NodeLatitude.dirty(position.latitude.toString());
      emit(state.copyWith(
        glStatus: GeolocationRequestStatus.success,
        longitude: longitude,
        latitude: latitude,
        node: state.node.rebuild((n) => n
          ..lng = position.longitude
          ..lat = position.latitude),
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
