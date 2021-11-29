import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:wikiclimb_flutter_frontend/core/entities/response.dart';

void main() {
  const tMessage = 'm';
  final tResponse = Response((r) => r
    ..error = false
    ..message = tMessage);

  test('equality', () {
    expect(
      tResponse,
      Response((r) => r
        ..error = false
        ..message = tMessage),
    );
  });

  test('to json', () {
    expect(
      jsonDecode(tResponse.toJson()),
      {'error': false, 'message': tMessage},
    );
  });

  test('from json', () {
    const jsonString = '{"error": false, "message": "$tMessage"}';
    expect(Response.fromJson(jsonString), tResponse);
  });
}
