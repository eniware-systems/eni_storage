import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

import 'package:eni_storage/src/storage_driver.dart';
import 'package:eni_utils/logger.dart';

/// Paths to Drift's WebAssembly runtime and worker file.
/// These files must be added to the web build under `assets/`.
const sqlite3WasmPath = "/assets/packages/eni_storage/sqlite3.wasm";
const driftWorkerPath = "/assets/packages/eni_storage/drift_worker.js";

/// Storage driver implementation for Web using Drift's WASM backend.
class WebStorageDriver implements StorageDriver {
  final _logger = loggerFor("WebStorageDriver");

  @override
  Future<QueryExecutor> openConnection(String databaseName) async {
    // Attempt to open a database using WASM and drift_worker
    final result = await WasmDatabase.open(
      databaseName: databaseName,
      sqlite3Uri: Uri.base.replace(path: sqlite3WasmPath, fragment: ""),
      driftWorkerUri: Uri.base.replace(path: driftWorkerPath, fragment: ""),
    );

    // Log missing browser features if any
    if (result.missingFeatures.isNotEmpty) {
      _logger.w(
        'Using ${result.chosenImplementation} due to missing browser '
        'features: ${result.missingFeatures}',
      );
    }

    return result.resolvedExecutor;
  }
}

// Singleton instance of the web storage driver
final _driver = WebStorageDriver();

/// Returns the platform-specific driver instance (in this case, web).
StorageDriver getStorageDriver() => _driver;
