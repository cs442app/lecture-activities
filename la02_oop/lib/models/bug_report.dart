import 'assignable.dart';
import 'comment.dart';
import 'commentable.dart';
import 'priority.dart';
import 'status.dart';
import 'task.dart';
import 'user.dart';

/// A bug report task with severity tracking and reproduction steps.
///
/// BugReport implements both [Assignable] and [Commentable], meaning it can
/// be assigned to a [User] and supports discussion via comments.
class BugReport extends Task implements Assignable, Commentable {
  /// Severity level from 1 (minor) to 5 (critical).
  final int severity;

  /// Steps to reproduce the bug.
  final List<String> stepsToReproduce;

  /// The platform where the bug was observed (e.g., "iOS", "Android", "Web").
  final String platform;

  @override
  final User? assignee;

  @override
  final List<Comment> comments;

  const BugReport({
    required super.id,
    required super.title,
    required super.description,
    required super.createdAt,
    super.dueDate,
    required super.priority,
    required super.status,
    super.tags,
    required this.severity,
    required this.stepsToReproduce,
    required this.platform,
    this.assignee,
    this.comments = const [],
  });

  // ---------------------------------------------------------------------------
  // Exercise 1: Implement the members below
  // ---------------------------------------------------------------------------

  @override
  String get type {
    // TODO: Return the type discriminator string for BugReport
    throw UnimplementedError();
  }

  /// Creates a [BugReport] from a JSON map.
  ///
  /// In addition to the base Task fields, parse:
  /// - `severity` (int)
  /// - `stepsToReproduce` (`List<String>`)
  /// - `platform` (String)
  /// - `assignee` (nested User JSON, may be null/missing)
  /// - `comments` (list of Comment JSON objects, may be missing/empty)
  factory BugReport.fromJson(Map<String, dynamic> json) {
    // TODO: Implement this factory constructor
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() {
    // TODO: Implement this method
    // Include all base Task fields plus severity, stepsToReproduce, platform,
    // assignee, and comments
    throw UnimplementedError();
  }

  /// Creates a critical bug report with maximum severity.
  ///
  /// Sets:
  /// - severity: 5
  /// - priority: [Priority.critical]
  /// - status: [Status.todo]
  /// - createdAt: current time
  /// - platform, description: empty string
  /// - no assignee, no comments, no tags
  //
  // TODO: Implement this named constructor.
  // Replace the factory below with a redirecting named constructor:
  //   BugReport.critical({...}) : this(...);
  factory BugReport.critical({
    required String title,
    required List<String> stepsToReproduce,
    String id = '',
  }) {
    throw UnimplementedError();
  }

  // ---------------------------------------------------------------------------
  // Exercise 2: Implement the interface methods below
  // ---------------------------------------------------------------------------

  @override
  BugReport assign(User user) {
    // TODO: Return a new BugReport identical to this one but with the given
    // user as assignee. All other fields (including comments) must be preserved.
    throw UnimplementedError();
  }

  @override
  BugReport unassign() {
    // TODO: Return a new BugReport with assignee set to null.
    throw UnimplementedError();
  }

  @override
  BugReport addComment(Comment comment) {
    // TODO: Return a new BugReport with the comment appended to the comments
    // list. The original comments list must not be modified.
    // Hint: Use [...comments, comment] to create a new list.
    throw UnimplementedError();
  }
}
