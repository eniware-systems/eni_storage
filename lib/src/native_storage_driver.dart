import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:eni_storage/src/storage_driver.dart';
import 'package:eni_utils/logger.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Storage driver implementation for native platforms (Android, iOS, desktop).
/// Uses Drift's NativeDatabase to open or create a SQLite file.
class NativeStorageDriver implements StorageDriver {
  final _logger = loggerFor("NativeStorageDriver");

  @override
  Future<QueryExecutor> openConnection(String databaseName) async {
    final dbFilename = '$databaseName.sqlite';

    // Get the directory where application-specific files can be stored.
    final dbFolder = await getApplicationSupportDirectory();
    final file = File(p.join(dbFolder.path, dbFilename));

    _logger.d("Opening database ${file.absolute}");

    // Create or open the SQLite database file in the background.
    return NativeDatabase.createInBackground(file);
  }
}

// Singleton instance of the native storage driver
final _driver = NativeStorageDriver();

/// Returns the platform-specific driver instance (in this case, native).
StorageDriver getStorageDriver() => _driver;
