import 'models/assignable.dart';
import 'models/priority.dart';
import 'models/status.dart';
// ignore: unused_import
import 'models/task.dart';
import 'task_board.dart';

/// A mixin that adds filtering capabilities to [TaskBoard].
///
/// Since [TaskBoard] is a "locked" class that you cannot modify, this mixin
/// demonstrates how to extend its functionality without changing its source.
///
/// Usage:
/// ```dart
/// class FilterableBoard extends TaskBoard with TaskFiltering {
///   FilterableBoard(super.name, super.tasks);
/// }
/// ```
mixin TaskFiltering on TaskBoard {
  /// Returns a new [TaskBoard] with only overdue tasks.
  ///
  /// A task is overdue if it has a due date that is before [DateTime.now()]
  /// and its status is not [Status.done].
  TaskBoard overdueTasks() {
    // TODO: Implement this method
    // Hint: Use the inherited `where` method from TaskBoard
    throw UnimplementedError();
  }

  /// Returns a new [TaskBoard] with only tasks matching the given [priority].
  TaskBoard tasksByPriority(Priority priority) {
    // TODO: Implement this method
    throw UnimplementedError();
  }

  /// Returns a new [TaskBoard] with only tasks matching the given [status].
  TaskBoard tasksByStatus(Status status) {
    // TODO: Implement this method
    throw UnimplementedError();
  }

  /// Returns a new [TaskBoard] with only unassigned tasks.
  ///
  /// A task is considered unassigned if it does not implement [Assignable],
  /// or if it implements [Assignable] but its assignee is null.
  TaskBoard unassignedTasks() {
    // TODO: Implement this method
    // Hint: Use `task is Assignable` to check interface implementation
    throw UnimplementedError();
  }
}
