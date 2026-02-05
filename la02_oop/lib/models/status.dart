/// Represents the current status of a task.
enum Status {
  todo,
  inProgress,
  review,
  done;

  /// Creates a [Status] from a JSON string value.
  factory Status.fromJson(String json) => values.byName(json);

  /// Converts this [Status] to a JSON string value.
  String toJson() => name;
}
