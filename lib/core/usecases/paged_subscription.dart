import 'package:dartz/dartz.dart';

import '../collections/page.dart';
import '../error/failure.dart';

/// This class allows treating collections
abstract class PagedSubscription<Type, Params> {
  /// Reload the first page of data.
  void refresh();

  /// Request the next page of data with the given parameters.
  void fetchPage({Params? params});

  /// Stream of paged items that consumers can subscribe to.
  Stream<Either<Failure, Page<Type>>> get subscribe;
}
