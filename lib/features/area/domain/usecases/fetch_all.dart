import 'package:dartz/dartz.dart';

import '../../../../core/collections/page.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/paged_subscription.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../node/domain/entities/node.dart';
import '../repository/area_repository.dart';

/// Fetch all areas without any criteria.
class FetchAllAreas extends PagedSubscription<Node, NoParams> {
  FetchAllAreas({required AreaRepository repository})
      : _repository = repository;

  final AreaRepository _repository;

  @override
  void fetchPage({NoParams? query, int? page}) {
    _repository.fetchPage();
  }

  @override
  void refresh() {
    fetchPage(page: null);
  }

  @override
  Stream<Either<Failure, Page<Node>>> get subscribe async* {
    yield* _repository.subscribe;
  }
}
