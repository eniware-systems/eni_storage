import 'package:eni_storage/src/storage_driver.dart';

const sqlite3WasmPath = "/assets/packages/eni_storage/sqlite3.wasm";
const driftWorkerPath = "/assets/packages/eni_storage/drift_worker.js";

StorageDriver getStorageDriver() {
  throw UnimplementedError("Platform is not supported");
}
