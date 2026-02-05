import 'user.dart';

/// Interface for tasks that can be assigned to a user.
///
/// Implementations should maintain immutability by returning new instances
/// from [assign] and [unassign] rather than modifying the current object.
abstract interface class Assignable {
  /// The user currently assigned to this task, or null if unassigned.
  User? get assignee;

  /// Returns a copy of this object with [user] as the assignee.
  Assignable assign(User user);

  /// Returns a copy of this object with no assignee.
  Assignable unassign();
}
