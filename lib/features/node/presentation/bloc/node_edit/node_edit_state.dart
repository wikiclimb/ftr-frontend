part of 'node_edit_bloc.dart';

enum GeolocationRequestStatus { initial, requested, success, failure, done }

/// The current state of the node edit taking place.
class NodeEditState extends Equatable {
  const NodeEditState({
    this.description = const NodeDescription.pure(),
    this.glStatus = GeolocationRequestStatus.initial,
    this.latitude = const NodeLatitude.pure(),
    this.longitude = const NodeLongitude.pure(),
    this.name = const NodeName.pure(),
    this.node,
    this.status = FormzStatus.pure,
    this.type = 0,
  });

  final NodeDescription description;
  final GeolocationRequestStatus glStatus;
  final NodeLatitude latitude;
  final NodeLongitude longitude;
  final NodeName name;
  final Node? node;
  final FormzStatus status;
  final int type;

  @override
  List<Object> get props => [
        status,
        glStatus,
        type,
        name,
        description,
        latitude,
        longitude,
      ];

  NodeEditState copyWith({
    FormzStatus? status,
    GeolocationRequestStatus? glStatus,
    int? type,
    NodeName? name,
    NodeDescription? description,
    NodeLatitude? latitude,
    NodeLongitude? longitude,
    Node? node,
  }) {
    return NodeEditState(
      status: status ?? this.status,
      glStatus: glStatus ?? this.glStatus,
      type: type ?? this.type,
      name: name ?? this.name,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      node: node ?? this.node,
    );
  }
}
