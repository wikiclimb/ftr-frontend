import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/image/images.dart';

void main() {
  test('value equality', () {
    final tImage = images.first;
    final tImage2 = images.first.rebuild((i) => i..id = 2);
    expect(tImage, isNot(equals(tImage2)));
    final tImage3 = tImage2.rebuild((p0) => p0..id = 1);
    expect(tImage, tImage3);
  });
}
