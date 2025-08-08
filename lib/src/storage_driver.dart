import 'package:drift/drift.dart';

// Platform-specific imports based on runtime environment:
// - Native: uses native SQLite
// - Web: uses WASM-based SQLite
// - Other: throws UnimplementedError by default
export './storage_driver_stub.dart'
    if (dart.library.html) './web_storage_driver.dart'
    if (dart.library.io) './native_storage_driver.dart';

/// Platform-agnostic abstraction for providing a Drift-compatible connection.
abstract class StorageDriver {
  /// Opens or creates a connection to a database identified by [databaseName].
  Future<QueryExecutor> openConnection(String databaseName);
}
