import 'package:eni_storage/eni_storage.dart';
import 'package:eni_svc/eni_svc.dart';
import 'package:flutter/material.dart';

import 'app_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ServiceScope(child: MyApp())
      ..addStorage(databaseName: "my_database")
      ..provide(DatabaseService()),
  );
}

class DatabaseService with Service {
  AppDatabase? _db;

  DatabaseService();

  AppDatabase get db {
    _db = _db ?? AppDatabase(services.storageConnection);
    return _db!;
  }
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final ValueNotifier<List<User>> users = ValueNotifier([]);

  void _addUsers(BuildContext context) async {
    final db = context.getService<DatabaseService>().db;
    await db.addUser('Alice');
    await db.addUser('Bob');
    await db.addUser('Charlie');
  }

  void _deleteUsers(BuildContext context) async {
    final db = context.getService<DatabaseService>().db;
    await db.delete(db.users).go();
  }

  @override
  Widget build(BuildContext context) {
    final db = context.getService<DatabaseService>().db;
    return MaterialApp(
        title: 'Eni storage example',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Row(
                children: [
                  const Text("Eni storage example"),
                  const SizedBox(width: 16), // Abstand
                  IconButton(
                    icon: const Icon(Icons.add),
                    tooltip: 'Add users',
                    onPressed: () => _addUsers(context),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    tooltip: 'Delete users',
                    onPressed: () => _deleteUsers(context),
                  ),
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder<List<User>>(
                stream: db.select(db.users).watch(),
                builder: (context, snapshot) {
                  final users = snapshot.data ?? [];
                  if (users.isEmpty) {
                    return const Center(child: Text("Keine User gefunden."));
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Users:",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            final user = users[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 1.0), // nur minimaler Abstand
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: 40, child: Text("${user.id}")),
                                  Expanded(child: Text(user.name)),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            )));
  }
}
