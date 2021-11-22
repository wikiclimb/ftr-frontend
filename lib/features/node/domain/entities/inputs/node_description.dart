import 'package:formz/formz.dart';

enum NodeDescriptionValidationError { empty }

/// Reactive [Node] description control.
class NodeDescription
    extends FormzInput<String, NodeDescriptionValidationError> {
  const NodeDescription.dirty([String value = '']) : super.dirty(value);

  const NodeDescription.pure([String value = '']) : super.pure(value);

  @override
  NodeDescriptionValidationError? validator(String? value) {
    return value?.isNotEmpty == true
        ? null
        : NodeDescriptionValidationError.empty;
  }
}
