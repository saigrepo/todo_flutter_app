import 'package:logger/logger.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../model/Task.dart';

class Back4AppHelper {
  static Logger log = Logger();
  // Create new item
  static Future<int> createItem(String title, String? description) async {
    int todoId = DateTime.now().millisecondsSinceEpoch;
    final saveTask = ParseObject('Task')
      ..set('todoId', todoId)
      ..set('title', title)
      ..set('description', description)
      ..set('completed', false);
    await saveTask.save();
    return todoId;
  }

  // Read all items
  static Future<List<Task>> getTasks() async {
    // ignore: non_constant_identifier_names
    List<Task> TasksList = [];
    QueryBuilder<ParseObject> queryPerson =
        QueryBuilder<ParseObject>(ParseObject('Task'));
    try {
      final ParseResponse apiResponse = await queryPerson.query();
      if (apiResponse.results != null) {
        TasksList = apiResponse.results!.map<Task>((result) {
          return Task.fromParseObject(result as ParseObject);
        }).toList();
      }
    } catch (E) {
      log.i('Error while Getting Tasks from Backend');
    }
    return TasksList;
  }

  // Read a single item by id
  static Future<Task?> getTask(int id) async {
    Task? task = null;
    QueryBuilder<ParseObject> queryPerson =
        QueryBuilder<ParseObject>(ParseObject('Task')..set('todoId', id));
    try {
      final ParseResponse apiResponse = await queryPerson.query();
      if (apiResponse.results != null) {
        task = apiResponse.result;
      }
    } catch (E) {
      log.i("Error while Getting Tasks from Backend");
    }
    return task;
  }

  // Update an task by id
  static Future<int> updateTask(
      int id, String title, String? description) async {
    final toUpdateTask = QueryBuilder(ParseObject('Task'))
      ..whereEqualTo('todoId', id);

    final ParseResponse apiResponse = await toUpdateTask.query();
    final ParseObject obj = apiResponse.result.first;
    obj.set('title', title);
    obj.set('description', description);
    obj.set('completed', false);
    await obj.save();
    return id;
  }

  static Future<void> updateStatusInTask(
      int id, String title, String desc, bool completed) async {
    final toUpdateTask = QueryBuilder(ParseObject('Task'))
      ..whereEqualTo('todoId', id);

    final ParseResponse apiResponse = await toUpdateTask.query();
    final ParseObject obj = apiResponse.result.first;
    obj.set('completed', completed);
    await obj.save();
  }

  // Delete an task
  static Future<void> deleteTask(int todoId) async {
    final deleteQuery = QueryBuilder(ParseObject('Task'))
      ..whereEqualTo('todoId', todoId);
    final response = await deleteQuery.query();
    final deletedObject = response.results!.first;
    await deletedObject.delete();
  }

  static Future<void> deleteTasks(bool completed) async {
    final deleteQuery = QueryBuilder(ParseObject('Task'))
      ..whereEqualTo('completed', completed);
    final response = await deleteQuery.query();
    final deletedObject = response.results as List;
    for (var delobj in deletedObject) {
      await delobj.delete();
    }
  }

  static Future<void> deleteAllTasks() async {
    final deleteQuery = QueryBuilder(ParseObject('Task'));
    final response = await deleteQuery.query();
    final deletedObject = response.results as List;
    for (var delobj in deletedObject) {
      await delobj.delete();
    }
  }
}
