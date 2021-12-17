// ignore_for_file: prefer_const_constructors
import 'package:built_collection/built_collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/bloc/node_list/node_list_bloc.dart';

import '../../../../../fixtures/node/nodes.dart';

void main() {
  final tState = NodeListState(
    status: NodeListStatus.initial,
    nodes: BuiltSet(),
    hasError: false,
    nextPage: 1,
  );

  group('initial', () {
    test('initial state supports value comparison', () {
      expect(
          NodeListState(
            status: NodeListStatus.loading,
            nodes: BuiltSet(),
            hasError: false,
            nextPage: 1,
          ),
          NodeListState(
            status: NodeListStatus.loading,
            nodes: BuiltSet(),
            hasError: false,
            nextPage: 1,
          ));
      expect(
        NodeListState(
          status: NodeListStatus.loaded,
          nodes: BuiltSet(nodes),
          hasError: false,
          nextPage: 3,
        ),
        NodeListState(
          status: NodeListStatus.loaded,
          nodes: BuiltSet(nodes),
          hasError: false,
          nextPage: 3,
        ),
      );
    });
  });

  test('copy with', () {
    expect(
      tState.copyWith(hasError: true),
      NodeListState(
        status: NodeListStatus.initial,
        nodes: BuiltSet(),
        hasError: true,
        nextPage: 1,
      ),
    );
    expect(
      tState.copyWith(
        status: NodeListStatus.loaded,
        nodes: BuiltSet(nodes),
        hasError: false,
        nextPage: 2,
      ),
      NodeListState(
        status: NodeListStatus.loaded,
        nodes: BuiltSet(nodes),
        hasError: false,
        nextPage: 2,
      ),
    );
  });
}
