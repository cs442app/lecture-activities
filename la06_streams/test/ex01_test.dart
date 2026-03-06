import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:la06_streams/alert_screen.dart';
import 'package:la06_streams/dashboard_screen.dart';
import 'package:la06_streams/history_screen.dart';
import 'package:la06_streams/models.dart';
import 'package:la06_streams/sensor_service.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

SensorReading _reading(String id, double v) =>
    SensorReading(sensorId: id, value: v, timestamp: DateTime.now());

// Each test gets fresh StreamControllers and a SensorService.fromStreams.
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

Widget _buildApp() => MaterialApp(home: DashboardScreen(service: _service));

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  setUp(_setUp);
  tearDown(_tearDown);

  group('Exercise 1 — StreamBuilder (DashboardScreen)', () {
    testWidgets('1-1: shows all three sensor labels',
        (tester) async {
      await tester.pumpWidget(_buildApp());
      expect(find.text('Temperature'), findsOneWidget);
      expect(find.text('Humidity'), findsOneWidget);
      expect(find.text('Pressure'), findsOneWidget);
    });

    testWidgets('1-2: shows -- for each sensor while waiting for first event',
        (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pump(); // let StreamBuilders enter waiting state
      expect(find.text('--'), findsNWidgets(3));
    });

    testWidgets('1-3: updates the temperature tile when the stream emits',
        (tester) async {
      await tester.pumpWidget(_buildApp());
      _tempCtrl.add(_reading('temperature', 23.4));
      await tester.pump();
      expect(find.text('23.4'), findsOneWidget);
    });

    testWidgets('1-4: all three tiles update independently',
        (tester) async {
      await tester.pumpWidget(_buildApp());
      _tempCtrl.add(_reading('temperature', 21.0));
      _humCtrl.add(_reading('humidity', 65.0));
      _presCtrl.add(_reading('pressure', 1012.0));
      await tester.pump();
      expect(find.text('21.0'), findsOneWidget);
      expect(find.text('65.0'), findsOneWidget);
      expect(find.text('1012.0'), findsOneWidget);
    });

    testWidgets('1-5: -- disappears once the stream delivers data',
        (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pump();
      expect(find.text('--'), findsNWidgets(3));

      _tempCtrl.add(_reading('temperature', 22.0));
      await tester.pump();
      // Only humidity and pressure tiles should still show --.
      expect(find.text('--'), findsNWidgets(2));
    });

    testWidgets('1-6: tapping a sensor tile navigates to HistoryScreen',
        (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pump();
      await tester.tap(find.text('Temperature'));
      await tester.pumpAndSettle();
      expect(find.byType(HistoryScreen), findsOneWidget);
    });

    testWidgets('1-7: alert icon button navigates to AlertScreen',
        (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.tap(find.byIcon(Icons.notifications_outlined));
      await tester.pumpAndSettle();
      expect(find.byType(AlertScreen), findsOneWidget);
    });
  });
}
