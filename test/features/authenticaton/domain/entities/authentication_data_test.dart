import 'package:flutter_test/flutter_test.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/entities/authentication_data.dart';

void main() {
  test('props returns id', () {
    const tAuthData = AuthenticationData(
      token: 'token-1',
      id: 123,
      username: 'test-username',
    );
    expect(
      tAuthData.props,
      [123],
      reason: 'Equatable props should only consider ID',
    );
  });

  test('authentication data equality comparison should work', () {
    const tAuthData1 = AuthenticationData(
      token: 'token-1',
      id: 123,
      username: 'test-username',
    );
    const tAuthData2 = AuthenticationData(
      token: 'token-2',
      id: 123,
      username: 'test-name',
    );
    expect(tAuthData1, tAuthData2,
        reason: 'models with same id should be considered equal');
  });
}
