import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    _loadDarkModePreference();
  }

  Future<void> _loadDarkModePreference() async {
    final darkMode = await Preferences.getDarkMode();
    setState(() {
      _darkMode = darkMode;
    });
  }

  void _toggleDarkMode(bool value) async {
    await Preferences.setDarkMode(value);
    setState(() {
      _darkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SQFLite Demo',
      theme: ThemeData(
        brightness: _darkMode ? Brightness.dark : Brightness.light,
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'Flutter SQFLite Demo',
        onThemeChanged: _toggleDarkMode,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title, required this.onThemeChanged})
      : super(key: key);
  final String? title;
  final Function(bool) onThemeChanged;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _titleController = TextEditingController();
  final _dbHelper = DBHelper();
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final items = await _dbHelper.getItems();
    setState(() {
      _items = items;
    });
  }

  void _addItem() async {
    if (_titleController.text.isNotEmpty) {
      await _dbHelper.insertItem({'title': _titleController.text});
      _titleController.clear();
      await _loadItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ThemeSwitcher(
              onChange: widget.onThemeChanged,
            ),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Enter item title',
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(title: Text(_items[index]['title'])),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        tooltip: 'Add Item',
        child: Icon(Icons.add),
      ),
    );
  }
}

class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({Key? key, required this.onChange}) : super(key: key);
  final Function(bool) onChange;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: const Text('Dark Mode'),
      value: Theme.of(context).brightness == Brightness.dark,
      onChanged: (bool value) {
        onChange(value);
      },
      secondary: const Icon(Icons.brightness_4),
    );
  }
}
