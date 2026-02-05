import 'priority.dart';
import 'status.dart';
import 'todo_task.dart';
import 'bug_report.dart';
import 'feature_request.dart';

/// Abstract base class for all task types.
///
/// This class defines the common fields shared by all tasks. Concrete
/// subclasses ([TodoTask], [BugReport], [FeatureRequest]) add type-specific
/// fields and behavior.
///
/// Use the [Task.fromJson] factory constructor to create the appropriate
/// subclass from JSON data — it inspects the `"type"` discriminator field
/// to determine which subclass to instantiate.
abstract class Task {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime? dueDate;
  final Priority priority;
  final Status status;
  final List<String> tags;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.dueDate,
    required this.priority,
    required this.status,
    this.tags = const [],
  });

  /// Creates the appropriate [Task] subclass from a JSON map.
  ///
  /// Inspects the `"type"` field to determine which subclass to instantiate:
  /// - `"todo"` -> [TodoTask]
  /// - `"bug"` -> [BugReport]
  /// - `"feature"` -> [FeatureRequest]
  ///
  /// Throws [ArgumentError] if the type is not recognized.
  factory Task.fromJson(Map<String, dynamic> json) {
    // TODO: Implement this factory constructor
    // 1. Read the 'type' field from the JSON map
    // 2. Use a switch expression or if/else to dispatch to the correct
    //    subclass's fromJson constructor:
    //    - 'todo'    -> TodoTask.fromJson(json)
    //    - 'bug'     -> BugReport.fromJson(json)
    //    - 'feature' -> FeatureRequest.fromJson(json)
    // 3. Throw ArgumentError for unknown types
    throw UnimplementedError();
  }

  /// The type discriminator string for JSON serialization.
  ///
  /// Each subclass must return its type identifier:
  /// - [TodoTask] -> `"todo"`
  /// - [BugReport] -> `"bug"`
  /// - [FeatureRequest] -> `"feature"`
  String get type;

  /// Converts this task to a JSON map.
  ///
  /// Subclasses must include the `"type"` discriminator field so that
  /// [Task.fromJson] can reconstruct the correct subclass.
  Map<String, dynamic> toJson();
}
