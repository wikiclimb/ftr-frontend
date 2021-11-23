// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';

import 'package:wikiclimb_flutter_frontend/core/error/failure.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/inputs/node_description.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/inputs/node_name.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/node.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/usecases/edit_node.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/bloc/node_edit/node_edit_bloc.dart';

import '../../../../../fixtures/node/nodes.dart';

class MockEditNode extends Mock implements EditNode {}

void main() {
  late EditNode mockEditNode;

  setUpAll(() {
    registerFallbackValue(nodes.first);
  });

  setUp(() {
    mockEditNode = MockEditNode();
  });

  test('initial state', () {
    final bloc = NodeEditBloc(mockEditNode);
    expect(bloc.state, NodeEditState());
  });

  group('initialize node', () {
    final tNode = nodes.first.rebuild((p0) => p0..type = 9);
    blocTest<NodeEditBloc, NodeEditState>(
      'valid name emits new valid state',
      build: () => NodeEditBloc(mockEditNode),
      act: (bloc) => bloc.add(NodeEditInitialize(tNode)),
      expect: () => <NodeEditState>[
        NodeEditState(
          type: 9,
          name: NodeName.pure(tNode.name),
          description: NodeDescription.pure(tNode.description ?? ''),
        ),
      ],
    );
  });

  group('name changed', () {
    final tNode = nodes.first;
    blocTest<NodeEditBloc, NodeEditState>(
      'valid name emits new valid state',
      build: () => NodeEditBloc(mockEditNode),
      act: (bloc) {
        bloc.add(NodeEditInitialize(tNode));
        bloc.add(NodeNameChanged('new name'));
      },
      expect: () => <NodeEditState>[
        NodeEditState(
          type: 1,
          name: NodeName.pure(tNode.name),
          description: NodeDescription.pure(tNode.description ?? ''),
        ),
        NodeEditState(
          status: FormzStatus.valid,
          type: 1,
          name: NodeName.dirty('new name'),
          description: NodeDescription.pure(tNode.description ?? ''),
        ),
      ],
    );
  });

  group('description changed', () {
    final tNode = nodes.first;
    blocTest<NodeEditBloc, NodeEditState>(
      'valid description emits new valid state',
      build: () => NodeEditBloc(mockEditNode),
      act: (bloc) {
        bloc.add(NodeEditInitialize(tNode));
        bloc.add(NodeDescriptionChanged('new description'));
      },
      expect: () => <NodeEditState>[
        NodeEditState(
          type: 1,
          name: NodeName.pure(tNode.name),
          description: NodeDescription.pure(tNode.description ?? ''),
        ),
        NodeEditState(
          status: FormzStatus.valid,
          type: 1,
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

    final state = NodeEditState(
      type: 1,
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
      build: () => NodeEditBloc(mockEditNode),
      act: (bloc) async {
        bloc.add(NodeEditInitialize(tNode));
        bloc.add(NodeNameChanged('new name'));
        bloc.add(NodeDescriptionChanged('new description'));
        bloc.add(NodeSubmissionRequested());
      },
      expect: () => <NodeEditState>[
        state,
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
      build: () => NodeEditBloc(mockEditNode),
      act: (bloc) async {
        bloc.add(NodeEditInitialize(tNode));
        bloc.add(NodeNameChanged('new name'));
        bloc.add(NodeDescriptionChanged('new description'));
        bloc.add(NodeSubmissionRequested());
      },
      expect: () => <NodeEditState>[
        state,
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
      build: () => NodeEditBloc(mockEditNode),
      act: (bloc) async {
        bloc.add(NodeEditInitialize(tNode));
        bloc.add(NodeNameChanged('new name'));
        bloc.add(NodeDescriptionChanged('new description'));
        bloc.add(NodeSubmissionRequested());
      },
      expect: () => <NodeEditState>[
        state,
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
      build: () => NodeEditBloc(mockEditNode),
      act: (bloc) async {
        bloc.add(NodeEditInitialize(tNode));
        bloc.add(NodeNameChanged('new name'));
        bloc.add(NodeDescriptionChanged('new description'));
        bloc.add(NodeSubmissionRequested());
      },
      expect: () => <NodeEditState>[
        state,
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
}
