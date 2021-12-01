import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/inputs/node_longitude.dart';

main() {
  const tValid = '-173.25';
  const tInvalid = '181.24';
  test('validation should pass for valid node longitude', () {
    const NodeLongitude nodeLongitude = NodeLongitude.pure();
    expect(nodeLongitude.validator(tValid), equals(null));
  });

  test('validation should fail for invalid node longitude', () {
    const NodeLongitude nodeLongitude = NodeLongitude.pure();
    expect(nodeLongitude.validator(tInvalid),
        NodeLongitudeValidationError.invalid);
  });

  test('status outputs correctly', () {
    const NodeLongitude nodeLongitude = NodeLongitude.dirty(tValid);
    expect(nodeLongitude.status, FormzInputStatus.valid);
  });

  test('invalid value', () {
    const NodeLongitude nodeLongitude = NodeLongitude.dirty(tInvalid);
    expect(nodeLongitude.status, FormzInputStatus.invalid);
  });
}
