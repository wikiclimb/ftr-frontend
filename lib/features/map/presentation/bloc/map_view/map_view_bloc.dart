import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:built_collection/built_collection.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../../../core/collections/page.dart';
import '../../../../../core/error/failure.dart';
import '../../../../node/domain/entities/node.dart';
import '../../../domain/usecases/fetch_areas_with_bounds.dart';

part 'map_view_event.dart';
part 'map_view_state.dart';

const throttleDuration = Duration(milliseconds: 500);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.debounce(duration), mapper);
  };
}

/// Manages state for a [MapView].
class MapViewBloc extends Bloc<MapViewEvent, MapViewState> {
  MapViewBloc({required FetchAreasWithBounds fetchAreasWithBounds})
      : _fetchAreasWithBounds = fetchAreasWithBounds,
        super(MapViewState(
          status: MapViewStatus.initial,
          nodes: BuiltSet(),
        )) {
    on<MapPositionChanged>(
      _onMapPositionChanged,
      transformer: throttleDroppable(throttleDuration),
    );
    on<PageAdded>(_onPageAdded);
    on<FailureResponse>(_onFailure);
    _subscription = _fetchAreasWithBounds.subscribe.listen((either) {
      either.fold(
        (failure) => add(FailureResponse()),
        (page) => add(PageAdded(page)),
      );
    });
  }

  final FetchAreasWithBounds _fetchAreasWithBounds;
  late final StreamSubscription<Either<Failure, Page<Node>>> _subscription;

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }

  void _onMapPositionChanged(MapPositionChanged event, Emitter emit) {
    emit(state.copyWith(
      status: MapViewStatus.loading,
    ));
    _fetchAreasWithBounds.fetch(
      position: event.position,
      nodes: state.nodes,
    );
  }

  void _onPageAdded(PageAdded event, Emitter emit) {
    // Limit the number of markers to one request of max 1000.
    emit(state.copyWith(
      status: MapViewStatus.loaded,
      nodes: (state.nodes.toBuilder()..addAll(event.page.items)).build(),
    ));
  }

  void _onFailure(event, emit) {
    emit(state.copyWith(status: MapViewStatus.failure));
  }
}
