import 'package:flutter/material.dart';
import 'todo_list_screen.dart'; // Import the TodoListScreen where the UI is now handled

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
      home: const TodoListScreen(), // The home screen is now the TodoListScreen
    );
  }
}
