import 'assignable.dart';
import 'comment.dart';
import 'commentable.dart';
// ignore: unused_import
import 'priority.dart';
// ignore: unused_import
import 'status.dart';
import 'task.dart';
import 'user.dart';

/// A feature request task with user story and acceptance criteria.
///
/// FeatureRequest implements both [Assignable] and [Commentable].
class FeatureRequest extends Task implements Assignable, Commentable {
  /// The user story describing the feature from the user's perspective.
  /// Format: "As a [role], I want [feature] so that [benefit]"
  final String userStory;

  /// List of criteria that must be met for the feature to be considered done.
  final List<String> acceptanceCriteria;

  /// Estimated effort in story points.
  final int effortEstimate;

  @override
  final User? assignee;

  @override
  final List<Comment> comments;

  const FeatureRequest({
    required super.id,
    required super.title,
    required super.description,
    required super.createdAt,
    super.dueDate,
    required super.priority,
    required super.status,
    super.tags,
    required this.userStory,
    required this.acceptanceCriteria,
    required this.effortEstimate,
    this.assignee,
    this.comments = const [],
  });

  // ---------------------------------------------------------------------------
  // Exercise 1: Implement the members below
  // ---------------------------------------------------------------------------

  @override
  String get type {
    // TODO: Return the type discriminator string for FeatureRequest
    throw UnimplementedError();
  }

  /// Creates a [FeatureRequest] from a JSON map.
  ///
  /// In addition to the base Task fields, parse:
  /// - `userStory` (String)
  /// - `acceptanceCriteria` (`List<String>`)
  /// - `effortEstimate` (int)
  /// - `assignee` (nested User JSON, may be null/missing)
  /// - `comments` (list of Comment JSON objects, may be missing/empty)
  factory FeatureRequest.fromJson(Map<String, dynamic> json) {
    // TODO: Implement this factory constructor
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() {
    // TODO: Implement this method
    throw UnimplementedError();
  }

  // ---------------------------------------------------------------------------
  // Exercise 2: Implement the interface methods below
  // ---------------------------------------------------------------------------

  @override
  FeatureRequest assign(User user) {
    // TODO: Return a new FeatureRequest with the given user as assignee
    throw UnimplementedError();
  }

  @override
  FeatureRequest unassign() {
    // TODO: Return a new FeatureRequest with assignee set to null
    throw UnimplementedError();
  }

  @override
  FeatureRequest addComment(Comment comment) {
    // TODO: Return a new FeatureRequest with the comment appended
    throw UnimplementedError();
  }
}
