import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:built_collection/built_collection.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wikiclimb_flutter_frontend/core/collections/page.dart';
import 'package:wikiclimb_flutter_frontend/core/error/failure.dart';
import 'package:wikiclimb_flutter_frontend/features/image/domain/entities/image.dart';
import 'package:wikiclimb_flutter_frontend/features/image/domain/usecases/fetch_all_images.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/node.dart';

part 'image_list_event.dart';
part 'image_list_state.dart';

/// Bloc that handles state of any widgets that display image lists.
///
/// The image pages can be requested and listened to via a subscription.
class ImageListBloc extends Bloc<ImageListEvent, ImageListState> {
  ImageListBloc({required FetchAllImages usecase})
      : _usecase = usecase,
        super(ImageListState(
          status: ImageListStatus.initial,
          images: BuiltSet(),
          hasError: false,
          nextPage: 1,
        )) {
    on<InitializationRequested>(_onInitializationRequested);
    on<PageAdded>(_onPageAdded);
    on<NextPageRequested>(_onNextPageRequested);
    on<FailureResponse>(_onFailure);
    _subscription = _usecase.subscribe.listen((either) {
      either.fold(
        (failure) => add(FailureResponse()),
        (page) => add(PageAdded(page)),
      );
    });
  }

  late final StreamSubscription<Either<Failure, Page<Image>>> _subscription;
  final FetchAllImages _usecase;

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }

  /// Initialize a newly created bloc instance.
  void _onInitializationRequested(InitializationRequested event, Emitter emit) {
    emit(state.copyWith(
      status: ImageListStatus.loading,
      node: event.node,
    ));
    // Trigger the initial data load.
    _usecase.fetchPage(params: _getParams());
  }

  void _onNextPageRequested(_, __) {
    _usecase.fetchPage(params: _getParams());
  }

  void _onPageAdded(PageAdded event, Emitter emit) {
    emit(state.copyWith(
      status: ImageListStatus.loaded,
      images: (state.images.toBuilder()..addAll(event.page.items)).build(),
      hasError: false,
      nextPage: event.page.nextPageNumber,
    ));
  }

  void _onFailure(event, emit) {
    emit(state.copyWith(
      status: ImageListStatus.loaded,
      hasError: true,
    ));
  }

  // Construct a parameter object that will be sent with the page request.
  Map<String, dynamic> _getParams() {
    Map<String, dynamic> params = {};
    if (state.nextPage > 0) {
      params.addAll({'page': state.nextPage.toString()});
    }
    final node = state.node;
    if (node != null) {
      params.addAll({'node-id': node.id.toString()});
    }
    return params;
  }
}
