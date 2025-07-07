import 'package:drift/drift.dart';
import 'package:eni_storage/src/storage_driver.dart';
import 'package:eni_svc/eni_svc.dart';
import 'package:flutter/widgets.dart';

export 'package:eni_storage/src/storage_driver.dart' show StorageDriver;

final _driver = getStorageDriver();

class StorageService with Service {
  final String _databaseName;
  late final QueryExecutor connection;

  StorageService({required String databaseName}) : _databaseName = databaseName;

  @override
  Future onPreInit(ServiceRegistry services) async {
    connection = await _driver.openConnection(_databaseName);
  }
}

extension ServiceRegistryStorageExtension on ImmutableServiceRegistry {
  StorageService get storage => getService<StorageService>();

  QueryExecutor get storageConnection => storage.connection;
}

extension BuildContextStorageExtension on BuildContext {
  StorageService get storage => getService<StorageService>();

  QueryExecutor get storageConnection => storage.connection;
}
