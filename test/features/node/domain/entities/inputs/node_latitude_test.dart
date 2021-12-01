import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/inputs/node_latitude.dart';

main() {
  const tValid = '-67.25';
  const tInvalid = '120';
  test('validation should pass for valid node latitude', () {
    const NodeLatitude nodeLatitude = NodeLatitude.pure();
    expect(nodeLatitude.validator(tValid), equals(null));
  });

  test('validation should fail for invalid node latitude', () {
    const NodeLatitude nodeLatitude = NodeLatitude.pure();
    expect(
        nodeLatitude.validator(tInvalid), NodeLatitudeValidationError.invalid);
  });

  test('status outputs correctly', () {
    const NodeLatitude nodeLatitude = NodeLatitude.dirty(tValid);
    expect(nodeLatitude.status, FormzInputStatus.valid);
  });

  test('invalid value', () {
    const NodeLatitude nodeLatitude = NodeLatitude.dirty(tInvalid);
    expect(nodeLatitude.status, FormzInputStatus.invalid);
  });
}
