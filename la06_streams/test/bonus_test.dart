import 'package:flutter_test/flutter_test.dart';

import 'package:la06_streams/history_screen.dart';
import 'package:la06_streams/models.dart';

// These tests only run when you have implemented replayReadings in
// lib/history_screen.dart.  Until then, each test will throw
// UnimplementedError, which counts as a failure — that is expected.

SensorReading _r(double v) => SensorReading(
      sensorId: 'temperature',
      value: v,
      timestamp: DateTime(2024, 1, 1),
    );

void main() {
  group('Bonus — async* / yield (replayReadings)', () {
    test('B-1: emits all readings from the list in order', () async {
      final history = [_r(20.0), _r(21.0), _r(22.0)];
      final result =
          await replayReadings(history, interval: Duration.zero).toList();
      expect(result.length, 3);
      expect(result[0].value, 20.0);
      expect(result[1].value, 21.0);
      expect(result[2].value, 22.0);
    });

    test('B-2: stream closes after the last reading', () async {
      final history = [_r(10.0), _r(11.0)];
      // toList() only completes when the stream closes — if the stream never
      // closes this test will time out.
      final result =
          await replayReadings(history, interval: Duration.zero).toList();
      expect(result.length, 2);
    });

    test('B-3: empty history produces an immediately-closing stream', () async {
      final result =
          await replayReadings([], interval: Duration.zero).toList();
      expect(result, isEmpty);
    });

    test('B-4: preserves sensorId and timestamp from the original readings',
        () async {
      final ts = DateTime(2024, 6, 15, 10, 30, 0);
      final reading = SensorReading(
          sensorId: 'humidity', value: 55.0, timestamp: ts);
      final result =
          await replayReadings([reading], interval: Duration.zero).toList();
      expect(result.single.sensorId, 'humidity');
      expect(result.single.value, 55.0);
      expect(result.single.timestamp, ts);
    });
  });
}
