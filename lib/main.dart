import 'package:flutter/material.dart';

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
  final List<Map<String, dynamic>> _todoItems = [
    {'title': 'Write a book', 'done': false},
    {'title': 'Do homework', 'done': false},
    {'title': 'Tidy room', 'done': true},
    {'title': 'Watch TV', 'done': false},
    {'title': 'Nap', 'done': false},
    {'title': 'Shop groceries', 'done': false},
    {'title': 'Have fun', 'done': false},
    {'title': 'Meditate', 'done': false},
  ];

  void _toggleDone(int index) {
    setState(() {
      _todoItems[index]['done'] = !_todoItems[index]['done'];
    });
  }

  void _removeTodoItem(int index) {
    setState(() {
      _todoItems.removeAt(index);
    });
  }

  void _addNewTask(String task) {
    setState(() {
      _todoItems.add({'title': task, 'done': false});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TIG333 TODO', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.grey[300],
        actions: [
          PopupMenuButton<String>(
            onSelected: (String result) {},
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'all',
                child: Text('All'),
              ),
              const PopupMenuItem(
                value: 'done',
                child: Text('Done'),
              ),
              const PopupMenuItem(
                value: 'undone',
                child: Text('Undone'),
              ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _todoItems.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              _buildTodoItem(_todoItems[index]['title'], _todoItems[index]['done'], index),
              const Divider(), // Add a divider after each item, including the last one
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the Add Task Screen
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
