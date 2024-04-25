import 'package:drift/drift.dart';

export './storage_driver_stub.dart'
    if (dart.library.html) './web_storage_driver.dart'
    if (dart.library.io) './native_storage_driver.dart';

abstract class StorageDriver {
  Future<QueryExecutor> openConnection(String databaseName);
}
