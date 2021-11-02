// coverage:ignore-file
import 'package:equatable/equatable.dart';

/// Contract for failure classes.
abstract class Failure extends Equatable {
  const Failure([List properties = const <dynamic>[]]);
}
