class Todo {
  final String id;
  final String title;
  final bool done;

  Todo({
    required this.id,
    required this.title,
    required this.done,
  });

  // From JSON (deserializing)
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      done: json['done'],
    );
  }

  // To JSON (serializing)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'done': done,
    };
  }
}
