import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:built_collection/built_collection.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/collections/page.dart';
import '../../../../../core/error/failure.dart';
import '../../../../node/domain/entities/node.dart';
import '../../../domain/usecases/fetch_all.dart';

part 'areas_event.dart';
part 'areas_state.dart';

/// Bloc for area listings.
class AreasBloc extends Bloc<AreasEvent, AreasState> {
  AreasBloc({required FetchAllAreas usecase})
      : _usecase = usecase,
        // Set the initial bloc state.
        super(AreasState(
          status: AreasStatus.initial,
          areas: BuiltSet(),
          hasError: false,
          nextPage: 1,
        )) {
    on<PageAdded>(_onPageAdded);
    on<NextPageRequested>(_onNextPageRequested);
    on<FailureResponse>(_onFailure);
    _subscription = _usecase.subscribe.listen((either) {
      either.fold(
        (failure) => add(FailureResponse()),
        (page) => add(PageAdded(page)),
      );
    });
    // Trigger the initial data load.
    _usecase.fetchPage();
  }

  late final StreamSubscription<Either<Failure, Page<Node>>> _subscription;
  final FetchAllAreas _usecase;

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }

  void _onNextPageRequested(_, __) {
    _usecase.fetchPage(params: _getParams());
  }

  void _onPageAdded(PageAdded event, Emitter emit) {
    emit(AreasState(
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

  Map<String, dynamic> _getParams() {
    Map<String, dynamic> params = {};
    if (state.nextPage > 0) {
      params.addAll({'page': state.nextPage.toString()});
    }
    // Add query parameters.
    return params;
  }
}
