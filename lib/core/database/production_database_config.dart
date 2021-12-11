// coverage:ignore-file

import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Manages creating database instances for the application.
abstract class DatabaseManager {
  LazyDatabase openProductionDatabase();
}

/// Implements the methods exposed in [DatabaseManager].
class DatabaseManagerImpl implements DatabaseManager {
  const DatabaseManagerImpl({required this.databaseName});

  final String databaseName;

  @override
  LazyDatabase openProductionDatabase() {
    // the LazyDatabase util lets us find the right location for the file async.
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, databaseName));
      return NativeDatabase(file);
    });
  }
}
