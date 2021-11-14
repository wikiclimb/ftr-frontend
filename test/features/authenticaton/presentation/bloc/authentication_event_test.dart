// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/entities/authentication_data.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/presentation/bloc/authentication_bloc.dart';

void main() {
  group('AuthenticationEvent', () {
    group('AuthenticationOK', () {
      const tAuthData = AuthenticationData(
        token: 'token',
        id: 132,
        username: 'username',
      );
      test('supports value comparisons', () {
        expect(AuthenticationOk(tAuthData), AuthenticationOk(tAuthData));
      });

      test('uses auth data as props', () {
        const event = AuthenticationOk(tAuthData);
        expect(event.props, [tAuthData]);
      });
    });

    group('AuthenticationKo', () {
      test('supports value comparisons', () {
        expect(AuthenticationKo(), AuthenticationKo());
      });
    });

    group('AuthenticationRequested', () {
      test('supports value comparisons', () {
        expect(AuthenticationRequested(), AuthenticationRequested());
      });
    });

    group('LogoutRequested', () {
      test('supports value comparisons', () {
        expect(LogoutRequested(), LogoutRequested());
      });
    });
  });
}
