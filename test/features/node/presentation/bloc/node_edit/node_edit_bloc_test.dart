// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wikiclimb_flutter_frontend/core/error/failure.dart';
import 'package:wikiclimb_flutter_frontend/core/utils/locator.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/inputs/inputs.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/inputs/node_description.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/inputs/node_name.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/node.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/usecases/edit_node.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/bloc/node_edit/node_edit_bloc.dart';

import '../../../../../fixtures/node/nodes.dart';

class MockEditNode extends Mock implements EditNode {}

class MockLocator extends Mock implements Locator {}

void main() {
  late EditNode mockEditNode;
  late final Locator mockLocator;

  setUpAll(() {
    registerFallbackValue(nodes.first);
    mockLocator = MockLocator();
    mockEditNode = MockEditNode();
  });

  group('initialize node', () {
    test('initial state', () {
      final bloc = NodeEditBloc(
        editNode: mockEditNode,
        locator: mockLocator,
        node: nodes.first,
      );
      expect(bloc.state, _getInitialState(nodes.first));
    });
  });

  group('name changed', () {
    final tNode = nodes.first;
    blocTest<NodeEditBloc, NodeEditState>(
      'valid name emits new valid state',
      build: () => NodeEditBloc(
        editNode: mockEditNode,
        locator: mockLocator,
        node: tNode,
      ),
      act: (bloc) {
        bloc.add(NodeNameChanged('new name'));
      },
      expect: () => <NodeEditState>[
        _getInitialState(tNode).copyWith(
          name: NodeName.dirty('new name'),
          status: FormzStatus.valid,
        ),
      ],
    );
  });

  group('longitude changed', () {
    final tNode = nodes.elementAt(3);
    const tLongitude = '-50.2';

    blocTest<NodeEditBloc, NodeEditState>(
      'valid longitude emits new valid state',
      build: () => NodeEditBloc(
        editNode: mockEditNode,
        locator: mockLocator,
        node: tNode,
      ),
      act: (bloc) {
        bloc.add(NodeLongitudeChanged(tLongitude));
      },
      expect: () => <NodeEditState>[
        NodeEditState(
          node: tNode,
          status: FormzStatus.valid,
          name: NodeName.pure(tNode.name),
          type: 1,
          longitude: NodeLongitude.dirty(tLongitude),
          latitude: NodeLatitude.pure(tNode.lat?.toString() ?? ''),
          description: NodeDescription.pure(tNode.description ?? ''),
        ),
      ],
    );
  });

  group('description changed', () {
    final tNode = nodes.first;
    blocTest<NodeEditBloc, NodeEditState>(
      'valid description emits new valid state',
      build: () => NodeEditBloc(
        editNode: mockEditNode,
        locator: mockLocator,
        node: tNode,
      ),
      act: (bloc) {
        bloc.add(NodeDescriptionChanged('new description'));
      },
      expect: () => <NodeEditState>[
        NodeEditState(
          status: FormzStatus.valid,
          type: 1,
          node: tNode,
          name: NodeName.pure(tNode.name),
          description: NodeDescription.dirty('new description'),
        ),
      ],
    );
  });

  group('submission requested with new node', () {
    final tNode = Node((n) => n
      ..name = 'old-name'
      ..type = 1);
    final expected = Node((n) => n
      ..name = 'new name'
      ..description = 'new description'
      ..type = 1);

    final state = _getInitialState(tNode);
    final state1 = state.copyWith(
      status: FormzStatus.invalid,
      name: NodeName.dirty('new name'),
    );
    final state2 = state1.copyWith(
      status: FormzStatus.valid,
      description: NodeDescription.dirty('new description'),
    );
    final state3 = state2.copyWith(
      status: FormzStatus.submissionInProgress,
    );
    final state4 = state3.copyWith(
      status: FormzStatus.submissionSuccess,
    );

    blocTest<NodeEditBloc, NodeEditState>(
      'submission success',
      setUp: () {
        when(() => mockEditNode(any())).thenAnswer(
          (_) async => Right(nodes.first),
        );
      },
      build: () => NodeEditBloc(
        editNode: mockEditNode,
        locator: mockLocator,
        node: tNode,
      ),
      act: (bloc) async {
        bloc.add(NodeNameChanged('new name'));
        bloc.add(NodeDescriptionChanged('new description'));
        bloc.add(NodeSubmissionRequested());
      },
      expect: () => <NodeEditState>[
        state1,
        state2,
        state3,
        state4,
      ],
      verify: (_) {
        verify(() => mockEditNode(expected)).called(1);
      },
    );

    const tLat = '83';
    const tLng = '120.003';
    final state3latLng = state2.copyWith(
      latitude: NodeLatitude.dirty(tLat),
    );
    final state4latLng = state3latLng.copyWith(
      longitude: NodeLongitude.dirty(tLng),
    );
    final state5latLng = state4latLng.copyWith(
      status: FormzStatus.submissionInProgress,
    );
    final state6latLng = state4latLng.copyWith(
      status: FormzStatus.submissionSuccess,
    );
    final expectedLatLng = expected.rebuild((n) => n
      ..lat = double.tryParse(tLat)
      ..lng = double.tryParse(tLng));

    blocTest<NodeEditBloc, NodeEditState>(
      'submission success with lat/lng',
      setUp: () {
        when(() => mockEditNode(any())).thenAnswer(
          (_) async => Right(nodes.first),
        );
      },
      build: () => NodeEditBloc(
        editNode: mockEditNode,
        locator: mockLocator,
        node: tNode,
      ),
      act: (bloc) async {
        bloc.add(NodeNameChanged('new name'));
        bloc.add(NodeDescriptionChanged('new description'));
        bloc.add(NodeLatitudeChanged(tLat));
        bloc.add(NodeLongitudeChanged(tLng));
        bloc.add(NodeSubmissionRequested());
      },
      expect: () => <NodeEditState>[
        state1,
        state2,
        state3latLng,
        state4latLng,
        state5latLng,
        state6latLng,
      ],
      verify: (_) {
        verify(() => mockEditNode(expectedLatLng)).called(1);
      },
    );

    final state4failed = state3.copyWith(
      status: FormzStatus.submissionFailure,
    );

    blocTest<NodeEditBloc, NodeEditState>(
      'submission failure',
      setUp: () {
        when(() => mockEditNode(any())).thenAnswer(
          (_) async => Left(UnauthorizedFailure()),
        );
      },
      build: () => NodeEditBloc(
        editNode: mockEditNode,
        locator: mockLocator,
        node: tNode,
      ),
      act: (bloc) async {
        bloc.add(NodeNameChanged('new name'));
        bloc.add(NodeDescriptionChanged('new description'));
        bloc.add(NodeSubmissionRequested());
      },
      expect: () => <NodeEditState>[
        state1,
        state2,
        state3,
        state4failed,
      ],
      verify: (_) {
        verify(() => mockEditNode(expected)).called(1);
      },
    );
  });

  group('submission requested with existing node', () {
    final tNode = Node((n) => n
      ..id = 22
      ..name = 'old-name'
      ..type = 1);
    final expected = Node((n) => n
      ..id = 22
      ..name = 'new name'
      ..description = 'new description'
      ..type = 1);

    final state = NodeEditState(
      type: 1,
      node: tNode,
      name: NodeName.pure(tNode.name),
      description: NodeDescription.pure(tNode.description ?? ''),
    );
    final state1 = state.copyWith(
      status: FormzStatus.invalid,
      name: NodeName.dirty('new name'),
    );
    final state2 = state1.copyWith(
      status: FormzStatus.valid,
      description: NodeDescription.dirty('new description'),
    );
    final state3 = state2.copyWith(
      status: FormzStatus.submissionInProgress,
    );
    final state4 = state3.copyWith(
      status: FormzStatus.submissionSuccess,
    );

    blocTest<NodeEditBloc, NodeEditState>(
      'submission success',
      setUp: () {
        when(() => mockEditNode(any())).thenAnswer(
          (_) async => Right(nodes.first),
        );
      },
      build: () => NodeEditBloc(
        editNode: mockEditNode,
        locator: mockLocator,
        node: tNode,
      ),
      act: (bloc) async {
        bloc.add(NodeNameChanged('new name'));
        bloc.add(NodeDescriptionChanged('new description'));
        bloc.add(NodeSubmissionRequested());
      },
      expect: () => <NodeEditState>[
        state1,
        state2,
        state3,
        state4,
      ],
      verify: (_) {
        verify(() => mockEditNode(expected)).called(1);
      },
    );

    final state4failed = state3.copyWith(
      status: FormzStatus.submissionFailure,
    );

    blocTest<NodeEditBloc, NodeEditState>(
      'submission failure',
      setUp: () {
        when(() => mockEditNode(any())).thenAnswer(
          (_) async => Left(UnauthorizedFailure()),
        );
      },
      build: () => NodeEditBloc(
        editNode: mockEditNode,
        locator: mockLocator,
        node: tNode,
      ),
      act: (bloc) async {
        bloc.add(NodeNameChanged('new name'));
        bloc.add(NodeDescriptionChanged('new description'));
        bloc.add(NodeSubmissionRequested());
      },
      expect: () => <NodeEditState>[
        state1,
        state2,
        state3,
        state4failed,
      ],
      verify: (_) {
        verify(() => mockEditNode(expected)).called(1);
      },
    );
  });

  group('geolocation requested', () {
    const tLatitude = 22.0;
    const tLongitude = -100.0;
    final tNode = nodes.first;
    final tPosition = Position(
      longitude: tLongitude,
      latitude: tLatitude,
      timestamp: DateTime.now(),
      accuracy: 1.0,
      altitude: 300,
      heading: 2.0,
      speed: 2.0,
      speedAccuracy: 2.0,
    );
    final state = NodeEditState(
      type: 1,
      node: tNode,
      name: NodeName.pure(tNode.name),
      description: NodeDescription.pure(tNode.description ?? ''),
    );
    final state1 = state.copyWith(glStatus: GeolocationRequestStatus.requested);
    final state2 = state1.copyWith(
      glStatus: GeolocationRequestStatus.success,
      latitude: NodeLatitude.dirty(tLatitude.toString()),
      longitude: NodeLongitude.dirty(tLongitude.toString()),
    );
    final state3 = state2.copyWith(glStatus: GeolocationRequestStatus.done);

    blocTest<NodeEditBloc, NodeEditState>(
      'with success result',
      setUp: () {
        when(() => mockLocator.determinePosition())
            .thenAnswer((_) async => tPosition);
      },
      build: () => NodeEditBloc(
        editNode: mockEditNode,
        locator: mockLocator,
        node: tNode,
      ),
      act: (bloc) async {
        bloc.add(NodeGeolocationRequested());
      },
      wait: Duration(milliseconds: 500),
      expect: () => <NodeEditState>[
        state1,
        state2,
        state3,
      ],
      verify: (_) {
        verify(() => mockLocator.determinePosition()).called(1);
      },
    );

    final state2Failure = state1.copyWith(
      glStatus: GeolocationRequestStatus.failure,
    );
    final state3Failure = state2Failure.copyWith(
      glStatus: GeolocationRequestStatus.initial,
    );

    blocTest<NodeEditBloc, NodeEditState>(
      'with failure result',
      setUp: () {
        when(() => mockLocator.determinePosition())
            .thenAnswer((_) => Future.error('location error'));
      },
      build: () => NodeEditBloc(
        editNode: mockEditNode,
        locator: mockLocator,
        node: tNode,
      ),
      act: (bloc) async {
        bloc.add(NodeGeolocationRequested());
      },
      wait: Duration(milliseconds: 500),
      expect: () => <NodeEditState>[
        state1,
        state2Failure,
        state3Failure,
      ],
      verify: (_) {
        verify(() => mockLocator.determinePosition()).called(1);
      },
    );
  });

  group('cover update requested', () {
    final tNode = nodes.first;
    final tUpdatedNode = tNode.rebuild((p0) => p0..coverUrl = 'fileName');
    final tState = _getInitialState(tNode);
    final tState1 = tState.copyWith(
      coverUpdateRequestStatus: CoverUpdateRequestStatus.loading,
    );
    final tState2 = tState.copyWith(
      coverUpdateRequestStatus: CoverUpdateRequestStatus.success,
      node: tUpdatedNode,
    );

    blocTest<NodeEditBloc, NodeEditState>(
      'with success result',
      setUp: () {
        when(() => mockEditNode(any())).thenAnswer(
          (_) async => Right(tUpdatedNode),
        );
      },
      build: () => NodeEditBloc(
        editNode: mockEditNode,
        locator: mockLocator,
        node: tNode,
      ),
      act: (bloc) async {
        bloc.add(NodeCoverUpdateRequested('fileName'));
      },
      expect: () => <NodeEditState>[
        tState1,
        tState2,
      ],
      verify: (_) {
        verify(() => mockEditNode(tUpdatedNode)).called(1);
      },
    );

    final tState2Failure = tState1.copyWith(
      coverUpdateRequestStatus: CoverUpdateRequestStatus.error,
    );

    blocTest<NodeEditBloc, NodeEditState>(
      'with failure result',
      setUp: () {
        when(() => mockEditNode(any()))
            .thenAnswer((_) async => Left(UnauthorizedFailure()));
      },
      build: () => NodeEditBloc(
        editNode: mockEditNode,
        locator: mockLocator,
        node: tNode,
      ),
      act: (bloc) async {
        bloc.add(NodeCoverUpdateRequested('fileName'));
      },
      expect: () => <NodeEditState>[
        tState1,
        tState2Failure,
      ],
      verify: (_) {
        verify(() => mockEditNode(tUpdatedNode)).called(1);
      },
    );
  });
}

/// This helper initializes a [NodeEditState] the same way that the bloc does.
NodeEditState _getInitialState(Node node) {
  return NodeEditState(
    node: node,
    type: node.type,
    name: NodeName.pure(node.name),
    description: NodeDescription.pure(node.description ?? ''),
    latitude: NodeLatitude.pure(node.lat?.toString() ?? ''),
    longitude: NodeLongitude.pure(node.lng?.toString() ?? ''),
  );
}
