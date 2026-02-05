import 'dart:convert';
import 'dart:io';

import 'package:la02_oop/la02_oop.dart';

/// Demo entry point that loads and displays tasks from the JSON data file.
///
/// Run with: dart run
void main() {
  final file = File('assets/tasks.json');
  final jsonString = file.readAsStringSync();
  final jsonList = jsonDecode(jsonString) as List<dynamic>;

  final tasks = jsonList
      .map((json) => Task.fromJson(json as Map<String, dynamic>))
      .toList();

  print('Loaded ${tasks.length} tasks:\n');
  for (final task in tasks) {
    final dueInfo = task.dueDate != null ? ' (due: ${task.dueDate})' : '';
    print('  [${task.type}] ${task.title}'
        ' — ${task.priority.name} / ${task.status.name}$dueInfo');
  }
}
