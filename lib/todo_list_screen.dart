import 'package:flutter/material.dart';
import 'todo_model.dart';
import 'api_service.dart';
import 'add_task_screen.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final ApiService apiService = ApiService();
  List<Todo> _todoItems = [];
  String _filter = 'all'; // default filter
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await apiService.loadApiKey();
      final todos = await apiService.fetchTodos();
      setState(() {
        _todoItems = todos;
        _isLoading = false;
      });
    } catch (e) {
      print('Error initializing: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Todo> _getFilteredTodos() {
    if (_filter == 'done') {
      return _todoItems.where((todo) => todo.done).toList();
    } else if (_filter == 'undone') {
      return _todoItems.where((todo) => !todo.done).toList();
    }
    return _todoItems; // Return all items if no filter is applied
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TIG333 TODO'),
        backgroundColor: Colors.grey[300],
        actions: [
          PopupMenuButton<String>(
            onSelected: (String result) {
              setState(() {
                _filter = result;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'all',
                child: Text('All'),
              ),
              const PopupMenuItem<String>(
                value: 'done',
                child: Text('Done'),
              ),
              const PopupMenuItem<String>(
                value: 'undone',
                child: Text('Undone'),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _getFilteredTodos().isEmpty
              ? const Center(child: Text('No todos yet'))
              : ListView.builder(
                  itemCount: _getFilteredTodos().length,
                  itemBuilder: (context, index) {
                    final todo = _getFilteredTodos()[index];
                    return Column(
                      children: [
                        ListTile(
                          leading: Checkbox(
                            value: todo.done,
                            onChanged: (bool? value) {
                              _toggleDone(todo);
                            },
                          ),
                          title: Text(
                            todo.title,
                            style: TextStyle(
                              decoration: todo.done ? TextDecoration.lineThrough : null,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => _deleteTodoItem(todo.id),
                          ),
                        ),
                        const Divider(),
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
      ),
    );
  }

  Future<void> _addNewTask(String title) async {
    await apiService.addTodo(title);
    _initialize(); // Refresh todos after adding
  }

  Future<void> _toggleDone(Todo todo) async {
    await apiService.toggleDone(todo);
    _initialize(); // Refresh todos after toggling
  }

  Future<void> _deleteTodoItem(String id) async {
    await apiService.deleteTodoItem(id);
    _initialize(); // Refresh todos after deleting
  }
}
