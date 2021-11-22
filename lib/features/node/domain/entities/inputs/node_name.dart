import 'package:formz/formz.dart';

enum NodeNameValidationError { empty, short }

/// Reactive [Node] name control.
class NodeName extends FormzInput<String, NodeNameValidationError> {
  const NodeName.dirty([String value = '']) : super.dirty(value);

  const NodeName.pure([String value = '']) : super.pure(value);

  @override
  NodeNameValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return NodeNameValidationError.empty;
    } else if (value.length < 4) {
      return NodeNameValidationError.short;
    }
    return null;
  }
}
