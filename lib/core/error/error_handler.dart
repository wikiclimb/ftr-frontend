import 'exception.dart';
import 'failure.dart';

/// Handles the common code that deals with converting exceptions to failures.
mixin ExceptionHandler {
  Failure exceptionToFailure(Exception e) {
    if (e is UnauthorizedException) {
      return UnauthorizedFailure();
    } else if (e is ForbiddenException) {
      return ForbiddenFailure();
    } else if (e is ServerException) {
      return ServerFailure();
    } else if (e is NetworkException) {
      return NetworkFailure();
    }
    return ApplicationFailure();
  }
}
