part of 'node_edit_bloc.dart';

/// The current state of the node edit taking place.
class NodeEditState extends Equatable {
  const NodeEditState({
    this.status = FormzStatus.pure,
    this.type = 0,
    this.name = const NodeName.pure(),
    this.description = const NodeDescription.pure(),
    this.latitude = const NodeLatitude.pure(),
    this.longitude = const NodeLongitude.pure(),
    this.node,
  });

  final NodeDescription description;
  final NodeLatitude latitude;
  final NodeLongitude longitude;
  final NodeName name;
  final Node? node;
  final FormzStatus status;
  final int type;

  @override
  List<Object> get props => [
        status,
        type,
        name,
        description,
        latitude,
        longitude,
      ];

  NodeEditState copyWith({
    FormzStatus? status,
    int? type,
    NodeName? name,
    NodeDescription? description,
    NodeLatitude? latitude,
    NodeLongitude? longitude,
    Node? node,
  }) {
    return NodeEditState(
      status: status ?? this.status,
      type: type ?? this.type,
      name: name ?? this.name,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      node: node ?? this.node,
    );
  }
}
