import 'assignable.dart';
import 'priority.dart';
import 'status.dart';
import 'task.dart';
import 'user.dart';

/// A simple to-do task.
///
/// TodoTask implements [Assignable], meaning it can be assigned to a [User].
class TodoTask extends Task implements Assignable {
  final bool isCompleted;

  @override
  final User? assignee;

  const TodoTask({
    required super.id,
    required super.title,
    required super.description,
    required super.createdAt,
    super.dueDate,
    required super.priority,
    required super.status,
    super.tags,
    this.isCompleted = false,
    this.assignee,
  });

  // ---------------------------------------------------------------------------
  // Exercise 1: Implement the members below
  // ---------------------------------------------------------------------------

  @override
  String get type {
    // TODO: Return the type discriminator string for TodoTask
    throw UnimplementedError();
  }

  /// Creates a [TodoTask] from a JSON map.
  ///
  /// See `assets/tasks.json` for example JSON structures. Key points:
  /// - Use [Priority.fromJson] and [Status.fromJson] for enum fields
  /// - Use [DateTime.parse] for date strings
  /// - `dueDate` and `assignee` may be null or missing — handle both cases
  /// - `tags` may be missing — default to an empty list
  /// - Use [User.fromJson] for the nested assignee object
  factory TodoTask.fromJson(Map<String, dynamic> json) {
    // TODO: Implement this factory constructor
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() {
    // TODO: Implement this method
    // Include all fields. Remember to:
    // - Use priority.toJson() and status.toJson() for enums
    // - Use createdAt.toIso8601String() for dates
    // - Conditionally include dueDate and assignee only when non-null
    // - Include the 'type' discriminator field
    throw UnimplementedError();
  }

  /// Creates a quick to-do with minimal information.
  ///
  /// Sets sensible defaults:
  /// - priority: [Priority.medium]
  /// - status: [Status.todo]
  /// - isCompleted: false
  /// - createdAt: current time
  /// - description: empty string
  /// - no assignee, no tags
  //
  // TODO: Implement this named constructor.
  // Replace the factory below with a redirecting named constructor:
  //   TodoTask.quick({...}) : this(...);
  factory TodoTask.quick({
    required String title,
    String id = '',
  }) {
    throw UnimplementedError();
  }

  // ---------------------------------------------------------------------------
  // Exercise 2: Implement the Assignable interface methods below
  // ---------------------------------------------------------------------------

  @override
  TodoTask assign(User user) {
    // TODO: Return a new TodoTask identical to this one but with the given
    // user as assignee. The original object must not be modified.
    throw UnimplementedError();
  }

  @override
  TodoTask unassign() {
    // TODO: Return a new TodoTask identical to this one but with assignee
    // set to null. The original object must not be modified.
    throw UnimplementedError();
  }
}
