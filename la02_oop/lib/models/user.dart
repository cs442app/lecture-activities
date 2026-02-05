/// Represents a user who can be assigned to tasks.
///
/// This is an immutable class — all fields are final.
class User {
  final String id;
  final String name;
  final String email;

  const User({
    required this.id,
    required this.name,
    required this.email,
  });

  /// Creates a [User] from a JSON map.
  ///
  /// Expected JSON format:
  /// ```json
  /// {"id": "user-001", "name": "Alice Chen", "email": "alice@example.com"}
  /// ```
  factory User.fromJson(Map<String, dynamic> json) {
    // TODO: Implement this factory constructor
    throw UnimplementedError();
  }

  /// Converts this [User] to a JSON map.
  Map<String, dynamic> toJson() {
    // TODO: Implement this method
    throw UnimplementedError();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          id == other.id &&
          name == other.name &&
          email == other.email;

  @override
  int get hashCode => Object.hash(id, name, email);

  @override
  String toString() => 'User(id: $id, name: $name, email: $email)';
}
