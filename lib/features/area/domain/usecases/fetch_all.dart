import 'package:dartz/dartz.dart';

import '../../../../core/collections/page.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/paged_subscription.dart';
import '../../../node/domain/entities/node.dart';
import '../repository/area_repository.dart';

/// Fetch all areas without any criteria.
class FetchAllAreas extends PagedSubscription<Node, Map<String, dynamic>> {
  FetchAllAreas({required AreaRepository repository})
      : _repository = repository;

  final AreaRepository _repository;

  @override
  Stream<Either<Failure, Page<Node>>> get subscribe async* {
    yield* _repository.subscribe;
  }

  @override
  void fetchPage({Map<String, dynamic>? params}) {
    _repository.fetchPage(params: params);
  }

  @override
  void refresh() {
    fetchPage();
  }
}
