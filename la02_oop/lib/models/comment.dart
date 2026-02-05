import 'user.dart';

/// Represents a comment on a task.
///
/// This is an immutable class — all fields are final.
class Comment {
  final String id;
  final User author;
  final String content;
  final DateTime createdAt;

  const Comment({
    required this.id,
    required this.author,
    required this.content,
    required this.createdAt,
  });

  /// Creates a [Comment] from a JSON map.
  ///
  /// Expected JSON format:
  /// ```json
  /// {
  ///   "id": "comment-001",
  ///   "author": {"id": "user-001", "name": "Alice", "email": "alice@example.com"},
  ///   "content": "This needs to be fixed ASAP",
  ///   "createdAt": "2024-01-20T14:30:00.000Z"
  /// }
  /// ```
  factory Comment.fromJson(Map<String, dynamic> json) {
    // TODO: Implement this factory constructor
    // Hint: The 'author' field is a nested User object — use User.fromJson()
    throw UnimplementedError();
  }

  /// Converts this [Comment] to a JSON map.
  Map<String, dynamic> toJson() {
    // TODO: Implement this method
    // Hint: Use author.toJson() for the nested User object
    throw UnimplementedError();
  }

  @override
  String toString() =>
      'Comment(id: $id, author: ${author.name}, content: $content)';
}
