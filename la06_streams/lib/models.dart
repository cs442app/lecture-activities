/// Data models for the Weather Station activity.
///
/// This file is provided — do not modify it.
library;

import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// SensorReading
// ---------------------------------------------------------------------------

/// A single reading emitted by a sensor stream.
class SensorReading {
  const SensorReading({
    required this.sensorId,
    required this.value,
    required this.timestamp,
  });

  /// Identifies which sensor produced this reading.
  /// One of: `'temperature'`, `'humidity'`, `'pressure'`.
  final String sensorId;

  /// The measured value in the sensor's native unit.
  final double value;

  /// Wall-clock time when the reading was taken.
  final DateTime timestamp;
}

// ---------------------------------------------------------------------------
// SensorConfig
// ---------------------------------------------------------------------------

/// Static metadata for one sensor: its id, display label, unit, and icon.
///
/// Use [kSensors] to iterate over all three sensors in display order.
class SensorConfig {
  const SensorConfig({
    required this.id,
    required this.label,
    required this.unit,
    required this.icon,
  });

  /// Machine-readable identifier; matches [SensorReading.sensorId].
  final String id;

  /// Human-readable name shown in the UI (e.g. `'Temperature'`).
  final String label;

  /// Unit suffix displayed next to the value (e.g. `'°C'`).
  final String unit;

  /// Material icon used in tile headers and list leading icons.
  final IconData icon;
}

/// All three sensor configurations in display order.
const kSensors = [
  SensorConfig(
    id: 'temperature',
    label: 'Temperature',
    unit: '°C',
    icon: Icons.thermostat,
  ),
  SensorConfig(
    id: 'humidity',
    label: 'Humidity',
    unit: '%',
    icon: Icons.water_drop,
  ),
  SensorConfig(
    id: 'pressure',
    label: 'Pressure',
    unit: 'hPa',
    icon: Icons.speed,
  ),
];

// ---------------------------------------------------------------------------
// Alert
// ---------------------------------------------------------------------------

/// An alert produced when a sensor reading exceeds a configured threshold.
class Alert {
  const Alert({
    required this.sensorLabel,
    required this.value,
    required this.unit,
    required this.threshold,
    required this.timestamp,
  });

  /// Display name of the sensor that triggered this alert.
  final String sensorLabel;

  /// The reading value that crossed the threshold.
  final double value;

  /// Unit for [value] and [threshold].
  final String unit;

  /// The threshold that [value] exceeded.
  final double threshold;

  /// Wall-clock time of the triggering reading.
  final DateTime timestamp;
}
