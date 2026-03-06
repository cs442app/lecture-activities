import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:la06_streams/alert_screen.dart';
import 'package:la06_streams/models.dart';
import 'package:la06_streams/sensor_service.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

SensorReading _reading(String id, double v) =>
    SensorReading(sensorId: id, value: v, timestamp: DateTime.now());

late StreamController<SensorReading> _tempCtrl;
late StreamController<SensorReading> _humCtrl;
late StreamController<SensorReading> _presCtrl;
late SensorService _service;

void _setUp() {
  _tempCtrl = StreamController<SensorReading>.broadcast();
  _humCtrl = StreamController<SensorReading>.broadcast();
  _presCtrl = StreamController<SensorReading>.broadcast();
  _service = SensorService.fromStreams(
    temperatureStream: _tempCtrl.stream,
    humidityStream: _humCtrl.stream,
    pressureStream: _presCtrl.stream,
  );
}

Future<void> _tearDown() async {
  await _tempCtrl.close();
  await _humCtrl.close();
  await _presCtrl.close();
}

Widget _buildApp() => MaterialApp(home: AlertScreen(service: _service));

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  setUp(_setUp);
  tearDown(_tearDown);

  group('Exercise 3 — Stream transformations (AlertScreen)', () {
    testWidgets('3-1: shows "No alerts yet." initially',
        (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pump();
      expect(find.text('No alerts yet.'), findsOneWidget);
    });

    testWidgets('3-2: readings at or below the threshold do not trigger alerts',
        (tester) async {
      await tester.pumpWidget(_buildApp()); // default threshold: 25.0
      _tempCtrl.add(_reading('temperature', 25.0)); // equal — should not alert
      await tester.pump();
      expect(find.text('No alerts yet.'), findsOneWidget);

      _tempCtrl.add(_reading('temperature', 24.9)); // below — should not alert
      await tester.pump();
      expect(find.text('No alerts yet.'), findsOneWidget);
    });

    testWidgets('3-3: a reading above the threshold triggers an alert',
        (tester) async {
      await tester.pumpWidget(_buildApp());
      _tempCtrl.add(_reading('temperature', 26.0));
      await tester.pump();
      expect(find.byType(ListTile), findsOneWidget);
      expect(find.textContaining('Temperature'), findsWidgets);
      expect(find.textContaining('26.0'), findsWidgets);
    });

    testWidgets('3-4: multiple above-threshold readings accumulate in the list',
        (tester) async {
      await tester.pumpWidget(_buildApp());
      for (final v in [26.0, 27.0, 28.0]) {
        _tempCtrl.add(_reading('temperature', v));
        await tester.pump();
      }
      expect(find.byType(ListTile), findsNWidgets(3));
    });

    testWidgets(
        '3-5: applying a new threshold clears old alerts and filters correctly',
        (tester) async {
      await tester.pumpWidget(_buildApp());
      _tempCtrl.add(_reading('temperature', 30.0)); // above default 25.0
      await tester.pump();
      expect(find.byType(ListTile), findsOneWidget);

      // Raise the threshold above the value we just saw.
      await tester.enterText(find.byType(TextField), '35.0');
      await tester.tap(find.text('Apply'));
      await tester.pump();

      // Old alerts should be cleared.
      expect(find.text('No alerts yet.'), findsOneWidget);

      // A reading below the new threshold should not trigger.
      _tempCtrl.add(_reading('temperature', 34.0));
      await tester.pump();
      expect(find.text('No alerts yet.'), findsOneWidget);

      // A reading above the new threshold should trigger.
      _tempCtrl.add(_reading('temperature', 36.0));
      await tester.pump();
      expect(find.byType(ListTile), findsOneWidget);
      expect(find.textContaining('36.0'), findsWidgets);
    });

    testWidgets(
        '3-6: switching sensor clears alerts and monitors the new sensor',
        (tester) async {
      await tester.pumpWidget(_buildApp());

      // Trigger an alert on the default sensor (Temperature).
      _tempCtrl.add(_reading('temperature', 30.0));
      await tester.pump();
      expect(find.byType(ListTile), findsOneWidget);

      // Switch to Humidity via the dropdown.
      await tester.tap(find.byType(DropdownButtonFormField<SensorConfig>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Humidity').last);
      await tester.pumpAndSettle();

      // Alerts should be cleared after the sensor change.
      expect(find.text('No alerts yet.'), findsOneWidget);

      // A temperature reading should no longer trigger an alert.
      _tempCtrl.add(_reading('temperature', 30.0));
      await tester.pump();
      expect(find.text('No alerts yet.'), findsOneWidget);

      // A humidity reading above the threshold should trigger.
      _humCtrl.add(_reading('humidity', 30.0));
      await tester.pump();
      expect(find.byType(ListTile), findsOneWidget);
      expect(find.textContaining('Humidity'), findsWidgets);
    });
  });
}
