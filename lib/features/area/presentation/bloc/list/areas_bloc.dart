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
import '../../../domain/usecases/fetch_all.dart';

part 'areas_event.dart';
part 'areas_state.dart';

const throttleDuration = Duration(milliseconds: 300);

EventTransformer<AreasEvent> throttleDroppable<AreasEvent>(Duration duration) {
  return (events, mapper) {
    return droppable<AreasEvent>().call(events.debounce(duration), mapper);
  };
}

/// Bloc for area listings.
class AreasBloc extends Bloc<AreasEvent, AreasState> {
  AreasBloc({required FetchAllAreas usecase, Node? parentNode})
      : _usecase = usecase,
        _parentNode = parentNode,
        // Set the initial bloc state.
        super(AreasState(
          status: AreasStatus.initial,
          areas: BuiltSet(),
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
  final FetchAllAreas _usecase;
  final Node? _parentNode;

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
      status: AreasStatus.loaded,
      areas: (state.areas.toBuilder()..addAll(event.page.items)).build(),
      hasError: false,
      nextPage: event.page.nextPageNumber,
    ));
  }

  void _onFailure(event, emit) {
    emit(AreasState(
      status: AreasStatus.loaded,
      areas: state.areas,
      hasError: true,
      nextPage: state.nextPage,
    ));
  }

  void _onSearchQueryUpdated(SearchQueryUpdated event, Emitter emit) {
    emit(state.copyWith(
      status: AreasStatus.loading,
      areas: BuiltSet(),
      hasError: false,
      nextPage: 1,
      query: event.query,
    ));
    _usecase.fetchPage(params: _getParams());
  }

  Map<String, String> _getParams() {
    Map<String, String> params = {};
    if (state.nextPage > 0) {
      params.addAll({'page': state.nextPage.toString()});
    }
    if (state.query.isNotEmpty) {
      params.addAll({'q': state.query});
    }
    if (_parentNode != null && _parentNode!.id != null) {
      params.addAll({'parent-id': _parentNode!.id!.toString()});
    }
    return params;
  }
}
