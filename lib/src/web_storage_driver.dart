import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

import 'package:eni_storage/src/storage_driver.dart';
import 'package:eni_utils/logger.dart';

const sqlite3WasmPath = "/assets/packages/eni_storage/sqlite3.wasm";
const driftWorkerPath = "/assets/packages/eni_storage/drift_worker.js";

class WebStorageDriver implements StorageDriver {
  final _logger = loggerFor("WebStorageDriver");

  @override
  Future<QueryExecutor> openConnection(String databaseName) async {
    final result = await WasmDatabase.open(
        databaseName: databaseName,
        sqlite3Uri: Uri.base.replace(path: sqlite3WasmPath, fragment: ""),
        driftWorkerUri: Uri.base.replace(path: driftWorkerPath, fragment: ""));

    if (result.missingFeatures.isNotEmpty) {
      _logger.w('Using ${result.chosenImplementation} due to missing browser '
          'features: ${result.missingFeatures}');
    }

    return result.resolvedExecutor;
  }
}

final _driver = WebStorageDriver();

StorageDriver getStorageDriver() => _driver;
