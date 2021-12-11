import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wikiclimb_flutter_frontend/core/database/database.dart';

void main() {
  late WkcDatabase database;

  setUp(() {
    database = WkcDatabase(NativeDatabase.memory());
  });

  test('can create', () {
    expect(database, isA<WkcDatabase>());
    expect(database.schemaVersion, equals(1));
  });
}
