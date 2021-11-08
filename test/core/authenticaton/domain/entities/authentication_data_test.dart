import 'package:flutter_test/flutter_test.dart';
import 'package:wikiclimb_flutter_frontend/core/authentication/domain/entities/authentication_data.dart';

void main() {
  test('authentication data equality comparison should work', () {
    const tAuthData1 = AuthenticationData(token: 'token', id: 123);
    const tAuthData2 = AuthenticationData(token: 'token', id: 123);
    expect(tAuthData1, tAuthData2,
        reason: 'models with same data should be equal');
  });
}
