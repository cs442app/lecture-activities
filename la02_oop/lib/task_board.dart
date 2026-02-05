import 'models/task.dart';

/// A simple task board that organizes tasks.
///
/// **DO NOT MODIFY THIS FILE.**
/// Use mixins and extensions to add functionality (see Exercise 3).
class TaskBoard {
  /// The name of this board.
  final String name;

  final List<Task> _tasks;

  /// Creates a [TaskBoard] with the given [name] and [tasks].
  ///
  /// The task list is made unmodifiable to preserve immutability.
  TaskBoard(this.name, List<Task> tasks) : _tasks = List.unmodifiable(tasks);

  /// All tasks on this board.
  List<Task> get tasks => _tasks;

  /// The number of tasks on this board.
  int get length => _tasks.length;

  /// Whether this board has no tasks.
  bool get isEmpty => _tasks.isEmpty;

  /// Whether this board has any tasks.
  bool get isNotEmpty => _tasks.isNotEmpty;

  /// Returns a new [TaskBoard] containing only tasks that match [predicate].
  TaskBoard where(bool Function(Task) predicate) {
    return TaskBoard(name, _tasks.where(predicate).toList());
  }

  /// Returns a new [TaskBoard] with [task] added.
  TaskBoard add(Task task) {
    return TaskBoard(name, [..._tasks, task]);
  }

  /// Returns a new [TaskBoard] with tasks sorted by [compare].
  TaskBoard sorted(int Function(Task a, Task b) compare) {
    final sortedTasks = List<Task>.from(_tasks)..sort(compare);
    return TaskBoard(name, sortedTasks);
  }
}
