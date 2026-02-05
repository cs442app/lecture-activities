/// Represents the priority level of a task.
enum Priority {
  low,
  medium,
  high,
  critical;

  /// Creates a [Priority] from a JSON string value.
  factory Priority.fromJson(String json) => values.byName(json);

  /// Converts this [Priority] to a JSON string value.
  String toJson() => name;
}
