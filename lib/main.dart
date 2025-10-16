import 'package:flutter/material.dart';
import 'services/database_helper.dart';

const pastelPurple = Color(0xFFD8B4E2);
final dbHelper = DatabaseHelper.instance;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pastel Purple SQLite',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: pastelPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder(
        future: dbHelper.init(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const MyHomePage();
          } else {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _idController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Pastel Purple SQLite',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: pastelPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: pastelPurple, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: pastelPurple.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'CRUD Operations',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: pastelPurple,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _insert,
                    icon: const Icon(Icons.add),
                    label: const Text('Insert Record'),
                    style: _buttonStyle(),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _query,
                    icon: const Icon(Icons.list_alt),
                    label: const Text('Query All Records'),
                    style: _buttonStyle(),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _update,
                    icon: const Icon(Icons.update),
                    label: const Text('Update Record'),
                    style: _buttonStyle(),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _delete,
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete Record'),
                    style: _buttonStyle(),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _idController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Enter ID to query',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _queryById,
                    icon: const Icon(Icons.search),
                    label: const Text('Query by ID'),
                    style: _buttonStyle(),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _deleteAll,
                    icon: const Icon(Icons.delete_forever),
                    label: const Text('Delete All Records'),
                    style: _buttonStyle(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: pastelPurple,
      foregroundColor: Colors.white,
      minimumSize: const Size(double.infinity, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  void _insert() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: 'Bob',
      DatabaseHelper.columnAge: 23
    };
    final id = await dbHelper.insert(row);
    debugPrint('Inserted row id: $id');
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    debugPrint('Query all rows:');
    for (final row in allRows) {
      debugPrint(row.toString());
    }
  }

  void _update() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: 1,
      DatabaseHelper.columnName: 'Mary',
      DatabaseHelper.columnAge: 32
    };
    final rowsAffected = await dbHelper.update(row);
    debugPrint('Updated $rowsAffected row(s)');
  }

  void _delete() async {
    final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id);
    debugPrint('Deleted $rowsDeleted row(s): row $id');
  }

  void _queryById() async {
    final input = _idController.text;
    if (input.isEmpty) return;
    final idToSearch = int.tryParse(input);
    if (idToSearch == null) return;
    final row = await dbHelper.queryRowById(idToSearch);
    if (row != null) {
      debugPrint('Record with ID $idToSearch: $row');
    } else {
      debugPrint('No record found with ID $idToSearch');
    }
  }

  void _deleteAll() async {
    final count = await dbHelper.deleteAll();
    debugPrint('Deleted $count record(s) from the database');
  }
}
