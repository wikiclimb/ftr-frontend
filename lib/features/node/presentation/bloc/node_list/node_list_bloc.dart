import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:built_collection/built_collection.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../../../core/collections/page.dart';
import '../../../../../core/error/failure.dart';
import '../../../../node/domain/entities/node.dart';
import '../../../domain/entities/node_fetch_params.dart';
import '../../../domain/usecases/fetch_all_nodes.dart';

part 'node_list_event.dart';
part 'node_list_state.dart';

const throttleDuration = Duration(milliseconds: 300);

EventTransformer<AreasEvent> throttleDroppable<AreasEvent>(Duration duration) {
  return (events, mapper) {
    return droppable<AreasEvent>().call(events.debounce(duration), mapper);
  };
}

/// Bloc for node listings.
class NodeListBloc extends Bloc<NodeListEvent, NodeListState> {
  NodeListBloc({required FetchAllNodes usecase, Node? parentNode, int? type})
      : _usecase = usecase,
        _parentNode = parentNode,
        _type = type,
        // Set the initial bloc state.
        super(NodeListState(
          status: NodeListStatus.initial,
          nodes: BuiltSet(),
          hasError: false,
          nextPage: 1,
        )) {
    on<PageAdded>(_onPageAdded);
    on<NextPageRequested>(
      _onNextPageRequested,
      transformer: throttleDroppable(throttleDuration),
    );
    on<FailureResponse>(_onFailure);
    on<SearchQueryUpdated>(_onSearchQueryUpdated);
    _subscription = _usecase.subscribe.listen((either) {
      either.fold(
        (failure) => add(FailureResponse()),
        (page) => add(PageAdded(page)),
      );
    });
    // Trigger the initial data load.
    _usecase.fetchPage(params: _getParams());
  }

  late final StreamSubscription<Either<Failure, Page<Node>>> _subscription;
  final FetchAllNodes _usecase;
  final Node? _parentNode;
  final int? _type;

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }

  void _onNextPageRequested(_, __) {
    _usecase.fetchPage(params: _getParams());
  }

  void _onPageAdded(PageAdded event, Emitter emit) {
    emit(state.copyWith(
      status: NodeListStatus.loaded,
      nodes: (state.nodes.toBuilder()..addAll(event.page.items)).build(),
      hasError: false,
      nextPage: event.page.nextPageNumber,
    ));
  }

  void _onFailure(event, emit) {
    emit(NodeListState(
      status: NodeListStatus.loaded,
      nodes: state.nodes,
      hasError: true,
      nextPage: state.nextPage,
    ));
  }

  void _onSearchQueryUpdated(SearchQueryUpdated event, Emitter emit) {
    emit(state.copyWith(
      status: NodeListStatus.loading,
      nodes: BuiltSet(),
      hasError: false,
      nextPage: 1,
      query: event.query,
    ));
    _usecase.fetchPage(params: _getParams());
  }

  NodeFetchParams _getParams() {
    return NodeFetchParams((p) => p
      ..type = _type
      ..page = state.nextPage
      ..perPage = 20
      ..query = state.query.isNotEmpty ? state.query : null
      ..parentId = _parentNode?.id);
  }
}
