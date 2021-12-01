import 'package:formz/formz.dart';

enum NodeLongitudeValidationError { invalid }

/// Reactive [Node] longitude control.
class NodeLongitude extends FormzInput<String, NodeLongitudeValidationError> {
  const NodeLongitude.dirty([String value = '']) : super.dirty(value);

  const NodeLongitude.pure([String value = '']) : super.pure(value);

  @override
  NodeLongitudeValidationError? validator(String? value) {
    if (value == null) {
      return null;
    }
    final lng = num.tryParse(value);
    if (lng != null && lng >= -180.0 && lng <= 180.0) {
      return null;
    }
    return NodeLongitudeValidationError.invalid;
  }
}
