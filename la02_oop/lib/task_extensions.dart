import 'models/assignable.dart';
import 'models/status.dart';
import 'models/task.dart';
import 'models/user.dart';

/// Extension methods on [List<Task>] for common task operations.
///
/// These methods provide convenient ways to sort, group, and analyze
/// collections of tasks without modifying the original list.
extension TaskListExtensions on List<Task> {
  /// Returns a new list of tasks sorted by due date (earliest first).
  ///
  /// Tasks without a due date should be placed at the end of the list.
  List<Task> sortedByDueDate() {
    // TODO: Implement this method
    // Hint: Use List.from(...) to avoid modifying the original, then sort.
    // Tasks with null dueDate go at the end.
    throw UnimplementedError();
  }

  /// Groups tasks by their assignee.
  ///
  /// Returns a map where keys are [User] objects (or null for unassigned
  /// tasks) and values are lists of tasks assigned to that user.
  ///
  /// A task is unassigned if it does not implement [Assignable] or if its
  /// assignee is null.
  Map<User?, List<Task>> groupByAssignee() {
    // TODO: Implement this method
    // Hint: Check if a task implements Assignable using `task is Assignable`
    throw UnimplementedError();
  }

  /// Calculates the completion rate as a value between 0.0 and 1.0.
  ///
  /// The completion rate is the fraction of tasks with [Status.done].
  /// Returns 0.0 if the list is empty.
  double completionRate() {
    // TODO: Implement this method
    throw UnimplementedError();
  }
}

/// Extension methods on [DateTime] for task-related date formatting.
extension TaskDateTimeExtensions on DateTime {
  /// Whether this date is in the past (i.e., the task is overdue).
  bool get isOverdue {
    // TODO: Implement this getter
    // Hint: Compare with DateTime.now()
    throw UnimplementedError();
  }

  /// A human-readable label describing when this date is relative to today.
  ///
  /// Returns strings like:
  /// - `"Due today"`
  /// - `"Due tomorrow"`
  /// - `"Due in 3 days"`
  /// - `"Due in 2 weeks"` (for 14+ days)
  /// - `"Overdue by 1 day"`
  /// - `"Overdue by 5 days"`
  /// - `"Overdue by 3 weeks"` (for 14+ days overdue)
  ///
  /// Use whole days only (ignore time of day). "Weeks" should be used for
  /// 14 or more days, calculated as `days ~/ 7`.
  String get dueLabel {
    // TODO: Implement this getter
    // Hint: Calculate the difference in days between this date and today.
    // Use DateTime.now() and the difference().inDays property.
    // Use DateUtils or manual calculation to strip time from both dates
    // before comparing (compare dates only, not times).
    throw UnimplementedError();
  }
}
