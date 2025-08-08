import 'package:eni_storage/eni_storage.dart';
import 'package:eni_svc/eni_svc.dart';

const defaultDatabaseName = "db";

/// Registers the eni_storage package as a `Package` in eni_svc.
/// This is typically only used internally during `addStorage()`.
class _StoragePackage extends Package {
  final String databaseName;

  @override
  String get name => "eni_storage";

  _StoragePackage({this.databaseName = defaultDatabaseName});

  @override
  void onRegister(ServiceRegistry services) {
    services.register(
      ServiceDescriptor.from(
        create: (_) => StorageService(databaseName: databaseName),
        name: "StorageService",
      ),
    );
  }
}

/// Extension method to easily add the storage service to the registry.
extension ServiceRegistryStoragePackageExtension on MutableServiceRegistry {
  void addStorage({String databaseName = defaultDatabaseName}) {
    final package = _StoragePackage(databaseName: databaseName);
    register(
      ServiceDescriptor.from(name: package.name, create: (_) => package),
    );
  }
}
