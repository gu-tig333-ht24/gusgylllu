import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'todo_model.dart';

class ApiService {
  final String apiUrl = 'https://todoapp-api.apps.k8s.gu.se/todos';
  String apiKey = '';

  Future<String> loadApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    final storedApiKey = prefs.getString('apiKey');
    if (storedApiKey != null) {
      apiKey = storedApiKey;
      return apiKey;
    } else {
      return registerUser();
    }
  }

  Future<String> registerUser() async {
    final response = await http.get(Uri.parse('https://todoapp-api.apps.k8s.gu.se/register'));
    if (response.statusCode == 200) {
      apiKey = response.body;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('apiKey', apiKey);
      return apiKey;
    } else {
      throw Exception('Failed to register API key');
    }
  }

  Future<List<Todo>> fetchTodos() async {
    final response = await http.get(Uri.parse('$apiUrl?key=$apiKey'));
    if (response.statusCode == 200) {
      final List<dynamic> todosJson = json.decode(response.body);
      return todosJson.map((json) => Todo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch todos');
    }
  }

  Future<void> addTodo(String title) async {
    final response = await http.post(
      Uri.parse('$apiUrl?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'title': title, 'done': false}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to add todo');
    }
  }

  Future<void> toggleDone(Todo todo) async {
    final response = await http.put(
      Uri.parse('$apiUrl/${todo.id}?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'title': todo.title, 'done': !todo.done}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update todo');
    }
  }

  Future<void> deleteTodoItem(String id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id?key=$apiKey'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete todo');
    }
  }
}
