// ignore_for_file: prefer_const_constructors

import 'package:drift/backends.dart';
import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wikiclimb_flutter_frontend/core/database/production_database_config.dart';

void main() {
  const dbName = 'test-db.sql';
  late DatabaseManager manager;

  setUp(() {
    manager = DatabaseManagerImpl(databaseName: dbName);
  });

  test('can create', () {
    expect(manager, isA<DatabaseManager>());
  });

  test('returns a database', () {
    final executor = manager.openProductionDatabase();
    expect(executor, isA<QueryExecutor>());
  });
}
