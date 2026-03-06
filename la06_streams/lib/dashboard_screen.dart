// ignore_for_file: unused_local_variable, unused_import, unused_element
import 'package:flutter/material.dart';

import 'alert_screen.dart';
import 'history_screen.dart';
import 'models.dart';
import 'sensor_service.dart';

/// The home screen — implement the TODOs below.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.service});

  final SensorService service;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void dispose() {
    widget.service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Station'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            tooltip: 'Set alerts',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => AlertScreen(service: widget.service)),
            ),
          ),
        ],
      ),
      // TODO 1a: Replace this Placeholder with a ListView.
      //
      // Use kSensors to build one tile per sensor:
      //   ListView(
      //     padding: const EdgeInsets.all(16),
      //     children: kSensors.map(_buildTile).toList(),
      //   )
      body: const Placeholder(),
    );
  }

  /// Returns a tappable Card that streams live readings for [config].
  Widget _buildTile(SensorConfig config) {
    // TODO 1b: Replace the Placeholder inside the Card with a
    // StreamBuilder<SensorReading> that listens to
    // widget.service.streamFor(config.id).
    //
    // TODO 1c: The StreamBuilder's builder should return:
    //   | Condition                | What to show                                        |
    //   |--------------------------|-----------------------------------------------------|
    //   | ConnectionState.waiting  | _buildValue('--', config.unit)                      |
    //   | snapshot.hasData         | _buildValue(                                        |
    //   |                          |   snapshot.data!.value.toStringAsFixed(1),          |
    //   |                          |   config.unit)                                      |
    //   | otherwise (error / done) | _buildValue('?', config.unit)                       |
    //
    // The StreamBuilder is the direct child of the Column entry that currently
    // holds the Placeholder below — it should replace that Placeholder.
    return Card(
      child: InkWell(
        // TODO 1d: Replace null with a callback that pushes HistoryScreen.
        //
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (_) => HistoryScreen(
        //         stream: widget.service.streamFor(config.id),
        //         config: config,
        //       ),
        //     ),
        //   );
        onTap: null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(config.icon, size: 40),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(config.label,
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    // Replace this Placeholder with your StreamBuilder.
                    // The StreamBuilder's builder should return _buildValue(...).
                    const Placeholder(fallbackHeight: 24),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  // Provided helper — do not modify.
  Widget _buildValue(String value, String unit) {
    return Row(
      children: [
        Text(value, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(width: 4),
        Text(unit, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
