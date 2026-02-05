/// Represents an analytics event from a mobile application.
class AppEvent {
  /// Unique identifier for the user who triggered this event
  final String userId;

  /// Type of event (e.g., 'login', 'purchase', 'page_view', 'error')
  final String eventType;

  /// When the event occurred
  final DateTime timestamp;

  /// Additional event-specific data (platform, version, page name, etc.)
  final Map<String, dynamic> metadata;

  /// Monetary value associated with the event (primarily for purchases)
  final double? value;

  const AppEvent({
    required this.userId,
    required this.eventType,
    required this.timestamp,
    required this.metadata,
    this.value,
  });

  /// Creates an AppEvent from a JSON map
  factory AppEvent.fromJson(Map<String, dynamic> json) {
    return AppEvent(
      userId: json['userId'] as String,
      eventType: json['eventType'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      metadata: Map<String, dynamic>.from(json['metadata'] as Map),
      value: json['value'] as double?,
    );
  }

  /// Converts this AppEvent to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'eventType': eventType,
      'timestamp': timestamp.toIso8601String(),
      'metadata': metadata,
      if (value != null) 'value': value,
    };
  }

  @override
  String toString() {
    return 'AppEvent(userId: $userId, eventType: $eventType, '
        'timestamp: $timestamp, value: $value)';
  }
}
