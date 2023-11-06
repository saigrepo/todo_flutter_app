import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class Task {
  final int todoId;
  final String title;
  final String description;
  bool completed;

  Task({
    required this.todoId,
    required this.title,
    required this.description,
    this.completed = false,
  });

  factory Task.fromParseObject(ParseObject object) {
    return Task(
      todoId: object.get('todoId'),
      title: object.get('title') ?? 'No titile',
      description: object.get('description') ?? 'No description',
      completed: object.get('completed'),
    );
  }
}
