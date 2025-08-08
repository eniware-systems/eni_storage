import 'package:drift/drift.dart';
import 'package:eni_storage/src/storage_driver.dart';
import 'package:eni_svc/eni_svc.dart';
import 'package:flutter/widgets.dart';

// Export the interface so consumers can access it externally
export 'package:eni_storage/src/storage_driver.dart' show StorageDriver;

/// Singleton instance of the platform-specific storage driver.
final _driver = getStorageDriver();

/// The main service that manages the database connection using Drift.
/// It is registered into the service registry via `addStorage()`.
class StorageService with Service {
  final String _databaseName;
  late final QueryExecutor connection;

  StorageService({required String databaseName}) : _databaseName = databaseName;

  @override
  Future onPreInit(ServiceRegistry services) async {
    // Open the database connection before services are initialized.
    connection = await _driver.openConnection(_databaseName);
  }
}

/// Extension for accessing the storage service or query executor from services.
extension ServiceRegistryStorageExtension on ImmutableServiceRegistry {
  StorageService get storage => getService<StorageService>();

  QueryExecutor get storageConnection => storage.connection;
}

/// Extension for accessing storage from widgets.
extension BuildContextStorageExtension on BuildContext {
  StorageService get storage => getService<StorageService>();

  QueryExecutor get storageConnection => storage.connection;
}
