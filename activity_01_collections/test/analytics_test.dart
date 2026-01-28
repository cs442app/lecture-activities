import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';
import 'package:activity_01_collections/models/app_event.dart';
import 'package:activity_01_collections/analytics.dart';

void main() {
  late List<AppEvent> events;

  setUpAll(() {
    // Load events from JSON file
    final file = File('assets/events.json');
    final jsonString = file.readAsStringSync();
    final jsonList = jsonDecode(jsonString) as List;
    events = jsonList.map((json) => AppEvent.fromJson(json)).toList();
  });

  group('revenueByPlatform', () {
    test('calculates total revenue correctly for each platform', () {
      final result = revenueByPlatform(events);

      expect(result['iOS'], closeTo(69.97, 0.01));
      expect(result['Android'], closeTo(49.97, 0.01));
    });

    test('returns empty map for events with no purchases', () {
      final noPurchases =
          events.where((e) => e.eventType != 'purchase').toList();
      final result = revenueByPlatform(noPurchases);

      expect(result.isEmpty || result.values.every((v) => v == 0), isTrue);
    });
  });

  group('activeUsersByHour', () {
    test('counts unique users per hour correctly', () {
      final result = activeUsersByHour(events);

      expect(result[8], equals(1)); // Only user_123
      expect(result[9], equals(3)); // user_456, user_789, user_123
      expect(result[10], equals(3)); // user_234, user_567, user_456
      expect(result[11], equals(2)); // user_890, user_345
    });

    test('does not double-count users with multiple events in same hour', () {
      final result = activeUsersByHour(events);

      // user_123 has multiple events in hour 8, but should only be counted once
      expect(result[8], equals(1));
    });
  });

  group('errorRateByPlatform', () {
    test('calculates error rates correctly', () {
      final result = errorRateByPlatform(events);

      // iOS: 2 errors out of 18 events = 0.111
      expect(result['iOS'], closeTo(0.111, 0.01));

      // Android: 2 errors out of 12 events ≈ 0.167
      expect(result['Android'], closeTo(0.167, 0.01));
    });

    test('returns 0.0 for platforms with no errors', () {
      final noErrors = events.where((e) => e.eventType != 'error').toList();
      final result = errorRateByPlatform(noErrors);

      expect(result.values.every((rate) => rate == 0.0), isTrue);
    });
  });

  group('topUsers', () {
    test('returns users sorted by event count descending', () {
      final result = topUsers(events, 5);

      expect(result.length, equals(5));
      expect(result[0].$1, equals('user_123')); // 5 events
      expect(result[0].$2, equals(5));
      expect(result[1].$1, equals('user_456')); // 5 events
      expect(result[1].$2, equals(5));

      // Verify descending order
      for (var i = 0; i < result.length - 1; i++) {
        expect(result[i].$2, greaterThanOrEqualTo(result[i + 1].$2));
      }
    });

    test('handles n larger than number of users', () {
      final result = topUsers(events, 100);

      // Should return all unique users without error
      expect(result.length,
          lessThanOrEqualTo(events.map((e) => e.userId).toSet().length));
    });

    test('handles n = 1', () {
      final result = topUsers(events, 1);

      expect(result.length, equals(1));
      expect(result[0].$2,
          greaterThanOrEqualTo(4)); // Top user has at least 4 events
    });
  });

  group('reconstructSessions', () {
    test('groups events by user correctly', () {
      final result = reconstructSessions(events);

      expect(result.containsKey('user_123'), isTrue);
      expect(result.containsKey('user_456'), isTrue);
      expect(result['user_123']!.length, equals(5));
      expect(result['user_456']!.length, equals(5));
    });

    test('sorts each user\'s events chronologically', () {
      final result = reconstructSessions(events);

      for (final userEvents in result.values) {
        for (var i = 0; i < userEvents.length - 1; i++) {
          expect(
              userEvents[i].timestamp.isBefore(userEvents[i + 1].timestamp) ||
                  userEvents[i]
                      .timestamp
                      .isAtSameMomentAs(userEvents[i + 1].timestamp),
              isTrue,
              reason: 'Events should be sorted chronologically');
        }
      }
    });

    test('user_123 session starts with login at 08:30', () {
      final result = reconstructSessions(events);
      final user123Events = result['user_123']!;

      expect(user123Events.first.eventType, equals('login'));
      expect(user123Events.first.timestamp.hour, equals(8));
      expect(user123Events.first.timestamp.minute, equals(30));
    });
  });
}
