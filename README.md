# eni_storage – Drift-Based Storage Driver for Flutter

**eni_storage** provides a unified, cross-platform storage solution for Flutter using [Drift](https://drift.simonbinder.eu/). It automatically selects the correct database driver depending on the platform (native or web) and integrates cleanly into apps built on the [`eni_svc`](https://github.com/eniware-systems/eni_svc) architecture.

---

## Features

- Unified storage interface for **mobile, desktop, and web**
- Platform-aware: uses `NativeDatabase` on IO and `WasmDatabase` on Web
- Integrates with `eni_svc` as a service
- Based on [Drift](https://pub.dev/packages/drift) for reactive persistence
- Minimal configuration – just plug in and go

---

## Getting Started

To begin using `eni_storage` in your project, simply install the package via:

```bash
dart pub add eni_storage
```


## Usage
1. Register the storage package in your app

```dart
services.addStorage(databaseName: "my_database");
```

This registers a StorageService and initializes a Drift connection for the given database name.
2. Access the storage connection

From any service:
```dart
final executor = services.storageConnection;
```
From a widget:
```dart
final db = context.storageConnection;
```
You can then pass this `QueryExecutor` into your `DriftDatabase` class.
## Architecture

`eni_storage` uses a driver-based architecture. Depending on the platform:
| Platform       | Driver                | Backend                             |
| -------------- | --------------------- | ----------------------------------- |
| Mobile/Desktop | `NativeStorageDriver` | SQLite via `NativeDatabase`         |
| Web            | `WebStorageDriver`    | SQLite via WASM & `drift_worker.js` |


Drivers implement a simple interface:

```dart
abstract class StorageDriver {
  Future<QueryExecutor> openConnection(String databaseName);
}
```
### Native (IO) Storage
```dart
// Uses getApplicationSupportDirectory() to store .sqlite file
final file = File('$appSupportDir/$databaseName.sqlite');
return NativeDatabase.createInBackground(file);
```
## Web Storage
```dart
return WasmDatabase.open(
  databaseName: databaseName,
  sqlite3Uri: sqlite3.wasm,
  driftWorkerUri: drift_worker.js,
);
```
## Example Drift Database
```dart
@DriftDatabase(tables: [Todos])
class MyDatabase extends _$MyDatabase {
  MyDatabase(QueryExecutor executor) : super(executor);

  @override
  int get schemaVersion => 1;
}
```
In your widget:
```dart
final db = MyDatabase(context.storageConnection);
```
## Web Setup

Make sure the following assets are bundled in your web build:
```yaml
flutter:
  assets:
    - assets/packages/eni_storage/sqlite3.wasm
    - assets/packages/eni_storage/drift_worker.js
```
These files are required by Drift’s WASM backend.

## Utilities
Access from Services
```dart
services.storage          // StorageService instance
services.storageConnection // QueryExecutor for Drift
```
Access from Widget Context
```dart
context.storage
context.storageConnection
```
## Configuration Defaults

- Default database name: `"db"`

- Default native path: `getApplicationSupportDirectory()`

- Default WASM files: `/assets/packages/eni_storage/sqlite3.wasm` and `drift_worker.js`

## Based On

- drift

- eni_svc

- path_provider

- sqlite3


## License
This package is proprietary software owned by [Eniware Systems GmbH](https://eniware-systems.de). All rights reserved.

Unauthorized reproduction or distribution of this package, or any portion of it, may result in severe civil and criminal penalties, and will be prosecuted to the maximum extent possible under the law.

For licensing inquiries or other questions, please contact [info@eniware-systems.de](mailto:info@eniware-systems.de)