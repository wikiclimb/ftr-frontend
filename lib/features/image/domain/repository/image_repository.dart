import 'package:dartz/dartz.dart';

import '../../../../core/collections/page.dart';
import '../../../../core/error/failure.dart';
import '../entities/image.dart';

/// This class provides contracts to interact with the image data layer.
abstract class ImageRepository {
  /// Subscribe to a stream of [Image] data.
  Stream<Either<Failure, Page<Image>>> get subscribe;

  /// Request one page of [Image] data. The page number can be passed to the
  /// method inside the [params] [Map] like `page: n`.
  /// The results will be pushed to the subscription.
  Future<Either<Failure, Page<Image>>> fetchPage(
      {Map<String, dynamic>? params});

  /// Clear up resources created by this repository.
  void dispose();
}
