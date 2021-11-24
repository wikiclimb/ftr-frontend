import 'package:dartz/dartz.dart';

import '../../../../core/collections/page.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/paged_subscription.dart';
import '../entities/image.dart';
import '../repository/image_repository.dart';

/// Fetch all images use case.
///
/// This usecase can take parameters that let callers filter the desired result.
class FetchAllImages extends PagedSubscription<Image, Map<String, dynamic>> {
  FetchAllImages(ImageRepository repository) : _repository = repository;

  final ImageRepository _repository;

  @override
  Stream<Either<Failure, Page<Image>>> get subscribe async* {
    yield* _repository.subscribe;
  }

  @override
  void fetchPage({Map<String, dynamic>? params}) {
    _repository.fetchPage(params: params);
  }

  // Request a refresh of the [Image] data.
  @override
  void refresh() {
    fetchPage();
  }
}
