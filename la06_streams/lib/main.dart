import 'package:flutter/material.dart';

import 'dashboard_screen.dart';
import 'sensor_service.dart';

void main() {
  runApp(const WeatherStationApp());
}

class WeatherStationApp extends StatelessWidget {
  const WeatherStationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Station',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: DashboardScreen(service: SensorService()),
    );
  }
}
