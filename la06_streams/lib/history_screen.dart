// ignore_for_file: unused_field, cancel_subscriptions, unused_element
import 'dart:async';

import 'package:flutter/material.dart';

import 'models.dart';

// ---------------------------------------------------------------------------
// Bonus function (implement last — see README)
// ---------------------------------------------------------------------------

/// Returns a [Stream] that replays [history] one reading at a time, waiting
/// [interval] between each emission.
///
/// Implement this using `async*` and `yield` (see the Bonus section of the
/// README for a full explanation).
///
/// This is a **standalone function**, not a method — it does not depend on
/// any widget state.
Stream<SensorReading> replayReadings(
  List<SensorReading> history, {
  Duration interval = const Duration(milliseconds: 500),
}) {
  // TODO Bonus: Replace this stub.
  //
  // An async* function is declared with `async*` instead of `async`.
  // Inside it, `yield` emits one value to the stream; the function then
  // suspends until the listener is ready for the next value.  You can also
  // use `await` between yields to introduce delays, just like in a regular
  // async function:
  //
  //   Stream<T> myStream() async* {
  //     for (final item in someList) {
  //       await Future.delayed(someDelay);
  //       yield item;
  //     }
  //   }  // ← stream closes naturally when the function returns
  //
  // Implement replayReadings so that it:
  //   1. Waits [interval] before emitting each reading.
  //   2. Yields the readings in order (first → last).
  //   3. Closes automatically after the final reading.
  throw UnimplementedError('replayReadings is not yet implemented');
}

// ---------------------------------------------------------------------------
// HistoryScreen
// ---------------------------------------------------------------------------

/// Shows an accumulating list of readings from one sensor.
///
/// Implement the TODOs below.
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({
    super.key,
    required this.stream,
    required this.config,
  });

  /// The stream of readings to accumulate.
  ///
  /// Passed in from [DashboardScreen] rather than obtained directly from the
  /// service, so both screens share the same underlying broadcast stream.
  final Stream<SensorReading> stream;

  /// Metadata (label, unit, icon) for the sensor being displayed.
  final SensorConfig config;

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // TODO 2a: Declare two fields:
  //   - A List<SensorReading> (initially empty) to hold accumulated readings.
  //   - A StreamSubscription<SensorReading>? to store the active subscription
  //     so you can cancel it in dispose().

  @override
  void initState() {
    super.initState();
    // TODO 2b: Subscribe to widget.stream.
    //
    // Each time a reading arrives, insert it at the front of your list and
    // call setState so the ListView rebuilds:
    //
    //   _subscription = widget.stream.listen((reading) {
    //     setState(() => _readings.insert(0, reading));
    //   });
    //
    // Inserting at index 0 keeps the most recent reading at the top of the
    // list without needing a separate sort.
  }

  @override
  void dispose() {
    // TODO 2c: Cancel your subscription to prevent memory leaks.
    //
    // Without this, the stream listener holds a reference to this State object
    // even after the widget is removed from the tree.  Any setState call that
    // arrives afterwards will throw an error — and the subscription will keep
    // running until the stream itself closes.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.config.label} History')),
      // TODO 2d: Replace this Placeholder.
      //
      // If your list is empty, show:
      //   const Center(child: Text('No readings yet.'))
      //
      // Otherwise, show a ListView.builder with one ListTile per reading:
      //   itemCount: _readings.length,
      //   itemBuilder: (context, index) {
      //     final reading = _readings[index];
      //     return ListTile(
      //       leading: Icon(widget.config.icon),
      //       title: Text(
      //         '${reading.value.toStringAsFixed(1)} ${widget.config.unit}',
      //       ),
      //       subtitle: Text(_formatTime(reading.timestamp)),
      //     );
      //   },
      body: const Placeholder(),
    );
  }

  // Provided helper — do not modify.
  String _formatTime(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:'
      '${dt.minute.toString().padLeft(2, '0')}:'
      '${dt.second.toString().padLeft(2, '0')}';
}
