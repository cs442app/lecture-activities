import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:la06_streams/history_screen.dart';
import 'package:la06_streams/models.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

const _config = SensorConfig(
  id: 'temperature',
  label: 'Temperature',
  unit: '°C',
  icon: Icons.thermostat,
);

SensorReading _reading(double v, {DateTime? at}) => SensorReading(
      sensorId: 'temperature',
      value: v,
      timestamp: at ?? DateTime.now(),
    );

late StreamController<SensorReading> _ctrl;

void _setUp() => _ctrl = StreamController<SensorReading>.broadcast();
Future<void> _tearDown() async => _ctrl.close();

Widget _buildApp() =>
    MaterialApp(home: HistoryScreen(stream: _ctrl.stream, config: _config));

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  setUp(_setUp);
  tearDown(_tearDown);

  group('Exercise 2 — StreamSubscription (HistoryScreen)', () {
    testWidgets('2-1: shows "No readings yet." before any events arrive',
        (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pump();
      expect(find.text('No readings yet.'), findsOneWidget);
    });

    testWidgets('2-2: displays a reading after the stream emits',
        (tester) async {
      await tester.pumpWidget(_buildApp());
      _ctrl.add(_reading(22.5));
      await tester.pump();
      expect(find.text('22.5 °C'), findsOneWidget);
    });

    testWidgets('2-3: list grows as more readings arrive',
        (tester) async {
      await tester.pumpWidget(_buildApp());
      for (int i = 0; i < 4; i++) {
        _ctrl.add(_reading(20.0 + i));
        await tester.pump();
      }
      expect(find.byType(ListTile), findsNWidgets(4));
    });

    testWidgets('2-4: most recent reading appears at the top of the list',
        (tester) async {
      await tester.pumpWidget(_buildApp());
      _ctrl.add(_reading(20.0));
      await tester.pump();
      _ctrl.add(_reading(21.0));
      await tester.pump();

      // Compare y-positions: 21.0 (newer) should be above 20.0 (older).
      final olderPos = tester.getTopLeft(find.text('20.0 °C'));
      final newerPos = tester.getTopLeft(find.text('21.0 °C'));
      expect(newerPos.dy, lessThan(olderPos.dy),
          reason: 'Most recent reading should appear above older readings');
    });

    testWidgets('2-5: "No readings yet." disappears once the first event arrives',
        (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pump();
      expect(find.text('No readings yet.'), findsOneWidget);

      _ctrl.add(_reading(19.0));
      await tester.pump();
      expect(find.text('No readings yet.'), findsNothing);
    });

    testWidgets('2-6: no errors after the widget is disposed',
        (tester) async {
      await tester.pumpWidget(_buildApp());
      _ctrl.add(_reading(20.0));
      await tester.pump();

      // Replace the widget tree — triggers dispose() on HistoryScreen.
      await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: Text('replaced'))));

      // Events added after dispose should not throw.
      _ctrl.add(_reading(21.0));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  });
}
