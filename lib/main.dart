import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TIG333 TODO',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final String apiUrl = 'https://todoapp-api.apps.k8s.gu.se/todos';
  String apiKey = '';
  List<Map<String, dynamic>> _todoItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _registerUser();
  }

  // 1. Register to get API key
  Future<void> _registerUser() async {
    try {
      final response = await http.get(Uri.parse('https://todoapp-api.apps.k8s.gu.se/register'));
      if (response.statusCode == 200) {
        setState(() {
          apiKey = response.body;
          print('API Key: $apiKey');
          _fetchTodos();
        });
      } else {
        print('Failed to register and get API key');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      print('Error during registration: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 2. Fetch todos from the API
  Future<void> _fetchTodos() async {
    if (apiKey.isEmpty) {
      print('API Key is empty, aborting fetch.');
      return;
    }

    setState(() {
      _isLoading = true; // Show loading spinner while fetching todos
    });

    try {
      final response = await http.get(Uri.parse('$apiUrl?key=$apiKey'));
      if (response.statusCode == 200) {
        final List<dynamic> todos = json.decode(response.body);
        setState(() {
          _todoItems = todos.map((item) => {
                'id': item['id'],
                'title': item['title'],
                'done': item['done'],
              }).toList();
          _isLoading = false;
        });
      } else {
        print('Failed to fetch todos. Status code: ${response.statusCode}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      print('Error fetching todos: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 3. Add a new todo to the API
  Future<void> _addNewTask(String task) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'title': task, 'done': false}),
      );
      if (response.statusCode == 200) {
        _fetchTodos(); // Refresh the list after adding
      } else {
        print('Failed to add new todo');
      }
    } catch (error) {
      print('Error adding new task: $error');
    }
  }

  // 4. Toggle the done status of a todo in the API
  Future<void> _toggleDone(int index) async {
    final todo = _todoItems[index];
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/${todo['id']}?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'title': todo['title'], 'done': !todo['done']}),
      );
      if (response.statusCode == 200) {
        _fetchTodos(); // Refresh the list after update
      } else {
        print('Failed to update todo');
      }
    } catch (error) {
      print('Error toggling done status: $error');
    }
  }

  // 5. Delete a todo from the API
  Future<void> _removeTodoItem(int index) async {
    final todo = _todoItems[index];
    try {
      final response = await http.delete(
        Uri.parse('$apiUrl/${todo['id']}?key=$apiKey'),
      );
      if (response.statusCode == 200) {
        _fetchTodos(); // Refresh the list after deletion
      } else {
        print('Failed to delete todo');
      }
    } catch (error) {
      print('Error deleting task: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TIG333 TODO', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.grey[300],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _todoItems.isEmpty
              ? const Center(child: Text('No todos yet'))
              : ListView.builder(
                  itemCount: _todoItems.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        _buildTodoItem(_todoItems[index]['title'], _todoItems[index]['done'], index),
                        const Divider(), // Adds a divider after each item
                      ],
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskScreen(onAdd: _addNewTask),
            ),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.grey[300],
        elevation: 6.0,
      ),
    );
  }

  Widget _buildTodoItem(String title, bool done, int index) {
    return ListTile(
      leading: Transform.scale(
        scale: 1.3,
        child: Checkbox(
          value: done,
          onChanged: (bool? value) {
            _toggleDone(index);
          },
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          decoration: done ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          _removeTodoItem(index);
        },
      ),
    );
  }
}

// Second Screen for adding a new task
class AddTaskScreen extends StatefulWidget {
  final Function(String) onAdd;

  const AddTaskScreen({super.key, required this.onAdd});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TIG333 TODO'),
        backgroundColor: Colors.grey[300],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'What are you going to do?',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  widget.onAdd(_controller.text);
                  Navigator.pop(context);
                }
              },
              child: const Text('+ ADD'),
            ),
          ],
        ),
      ),
    );
  }
}
