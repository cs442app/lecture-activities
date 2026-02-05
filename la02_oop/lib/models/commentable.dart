import 'comment.dart';

/// Interface for tasks that support comments and discussion.
///
/// Implementations should maintain immutability by returning new instances
/// from [addComment] rather than modifying the current object.
abstract interface class Commentable {
  /// The list of comments on this task.
  List<Comment> get comments;

  /// Returns a copy of this object with [comment] added to the comments list.
  Commentable addComment(Comment comment);
}
