import 'package:drift/drift.dart';
import 'users.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Users])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

  // Beispiel-Methoden
  Future<int> addUser(String name) {
    return into(users).insert(UsersCompanion(name: Value(name)));
  }

  Future<List<User>> getAllUsers() {
    return select(users).get();
  }
}
