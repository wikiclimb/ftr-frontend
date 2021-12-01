import 'package:formz/formz.dart';

enum NodeLatitudeValidationError { invalid }

/// Reactive [Node] latitude control.
class NodeLatitude extends FormzInput<String, NodeLatitudeValidationError> {
  const NodeLatitude.dirty([String value = '']) : super.dirty(value);

  const NodeLatitude.pure([String value = '']) : super.pure(value);

  @override
  NodeLatitudeValidationError? validator(String? value) {
    if (value == null) {
      return null;
    }
    final lat = num.tryParse(value);
    if (lat != null && lat >= -90.0 && lat <= 90.0) {
      return null;
    }
    return NodeLatitudeValidationError.invalid;
  }
}
