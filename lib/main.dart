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
  final TextEditingController _controller = TextEditingController();
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _todoItems.length,
              itemBuilder: (context, index) {
                return _buildTodoItem(_todoItems[index]['title'], _todoItems[index]['done'], index);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,//will call a function to add todo item to list.
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
            //will later call a method for the ability to toggle completed tasks on the todo list 
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
          //will call a function to remove todo item from list.
        },
      ),
    );
  }
}
