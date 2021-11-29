// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:wikiclimb_flutter_frontend/core/error/exception.dart';

void main() {
  const tMessage = 'Error';
  final tException = ApplicationException(message: tMessage);

  test('equality', () {
    expect(
      tException,
      ApplicationException(message: tMessage),
    );
  });

  test('props', () {
    expect(tException.props, [tMessage]);
  });

  test('message', () {
    expect(tException.message, tMessage);
  });

  test('subclasses', () {
    expect(
      CacheException(message: tMessage),
      CacheException(message: tMessage),
    );
    expect(
      NetworkException(message: tMessage),
      isNot(equals(NetworkException(message: 'other message'))),
    );
    expect(
      NetworkException(message: tMessage),
      NetworkException(message: tMessage),
    );
    expect(
      ServerException(message: tMessage),
      ServerException(message: tMessage),
    );
    expect(
      UnauthorizedException(message: tMessage),
      UnauthorizedException(message: tMessage),
    );
    expect(
      ForbiddenException(message: tMessage),
      ForbiddenException(message: tMessage),
    );
    expect(
      NetworkException(message: tMessage),
      isNot(equals(CacheException(message: tMessage))),
    );
  });
}
