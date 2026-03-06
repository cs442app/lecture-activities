// ignore_for_file: unused_field, cancel_subscriptions, unused_import, prefer_final_fields, unused_element
import 'dart:async';

import 'package:flutter/material.dart';

import 'models.dart';
import 'sensor_service.dart';

/// Lets the user configure a sensor threshold and watch live alerts.
///
/// Implement the TODOs below.
class AlertScreen extends StatefulWidget {
  const AlertScreen({super.key, required this.service});

  final SensorService service;

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  SensorConfig _selectedSensor = kSensors.first; // initially Temperature
  double _threshold = 25.0;
  final _thresholdController = TextEditingController(text: '25.0');

  // TODO 3a: Declare two fields:
  //   - A List<Alert> (initially empty) to hold accumulated alerts.
  //   - A StreamSubscription<Alert>? to hold the active subscription.

  @override
  void initState() {
    super.initState();
    // TODO 3b: Call _updateAlertStream() to set up the initial subscription.
  }

  @override
  void dispose() {
    // TODO 3c: Cancel your subscription and dispose of _thresholdController.
    _thresholdController.dispose();
    super.dispose();
  }

  /// Cancels any existing subscription and creates a new one based on
  /// the current values of [_selectedSensor] and [_threshold].
  ///
  /// Call this whenever either value changes so the stream pipeline is rebuilt
  /// from scratch with the latest filter settings.
  void _updateAlertStream() {
    // TODO 3d: Implement this method in four steps.
    //
    // Step 1 — Cancel any existing subscription so the old listener stops
    //   receiving events:
    //     _subscription?.cancel();
    //
    // Step 2 — Reset _alerts to an empty list so stale alerts from the
    //   previous sensor / threshold are cleared from the UI:
    //     _alerts = [];
    //
    // Step 3 — Build a transformed stream pipeline:
    //
    //   final alertStream = widget.service
    //       .streamFor(_selectedSensor.id)
    //       .where((reading) => reading.value > _threshold)
    //       .map((reading) => Alert(
    //             sensorLabel: _selectedSensor.label,
    //             value:        reading.value,
    //             unit:         _selectedSensor.unit,
    //             threshold:    _threshold,
    //             timestamp:    reading.timestamp,
    //           ));
    //
    //   .where() returns a new Stream that only emits events for which the
    //   predicate returns true — readings at or below the threshold are dropped.
    //
    //   .map() transforms each remaining SensorReading into an Alert.  The
    //   result, alertStream, is a Stream<Alert>.
    //
    // Step 4 — Subscribe to alertStream; insert each Alert at the front of
    //   _alerts and call setState:
    //
    //   _subscription = alertStream.listen((alert) {
    //     setState(() => _alerts.insert(0, alert));
    //   });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alerts')),
      body: Column(
        children: [
          // --- Filter controls (provided — do not modify) ---
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<SensorConfig>(
                  // ignore: deprecated_member_use
                  value: _selectedSensor,
                  decoration: const InputDecoration(
                    labelText: 'Sensor',
                    border: OutlineInputBorder(),
                  ),
                  items: kSensors
                      .map((s) =>
                          DropdownMenuItem(value: s, child: Text(s.label)))
                      .toList(),
                  onChanged: (config) {
                    if (config == null) return;
                    // TODO 3e: Update _selectedSensor inside setState, then
                    // call _updateAlertStream() to rebuild the pipeline:
                    //
                    //   setState(() => _selectedSensor = config);
                    //   _updateAlertStream();
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _thresholdController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: InputDecoration(
                          labelText: 'Alert above',
                          suffixText: _selectedSensor.unit,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    FilledButton(
                      onPressed: () {
                        final value =
                            double.tryParse(_thresholdController.text);
                        if (value == null) return;
                        // TODO 3f: Update _threshold inside setState, then
                        // call _updateAlertStream():
                        //
                        //   setState(() => _threshold = value);
                        //   _updateAlertStream();
                      },
                      child: const Text('Apply'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          // --- Alert list ---
          // TODO 3g: Replace this Placeholder.
          //
          // If _alerts is empty, show:
          //   const Expanded(child: Center(child: Text('No alerts yet.')))
          //
          // Otherwise show an Expanded ListView.builder with one ListTile
          // per alert (index 0 = most recent):
          //
          //   leading:  const Icon(Icons.warning_amber, color: Colors.orange)
          //   title:    Text(
          //               '${alert.sensorLabel}: '
          //               '${alert.value.toStringAsFixed(1)} ${alert.unit}',
          //             )
          //   subtitle: Text(
          //               '${_formatTime(alert.timestamp)} — '
          //               'above ${alert.threshold.toStringAsFixed(1)} '
          //               '${alert.unit}',
          //             )
          const Expanded(child: Placeholder()),
        ],
      ),
    );
  }

  // Provided helper — do not modify.
  String _formatTime(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:'
      '${dt.minute.toString().padLeft(2, '0')}:'
      '${dt.second.toString().padLeft(2, '0')}';
}
