import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:eni_storage/src/storage_driver.dart';
import 'package:eni_utils/logger.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class NativeStorageDriver implements StorageDriver {
  final _logger = loggerFor("NativeStorageDriver");

  @override
  Future<QueryExecutor> openConnection(String databaseName) async {
    final dbFilename = '$databaseName.sqlite';

    final dbFolder = await getApplicationSupportDirectory();
    final file = File(p.join(dbFolder.path, dbFilename));

    _logger.d("Opening database ${file.absolute}");

    return NativeDatabase.createInBackground(file);
  }
}

final _driver = NativeStorageDriver();

StorageDriver getStorageDriver() => _driver;
