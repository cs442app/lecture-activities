/// Simulated sensor service for the Weather Station activity.
///
/// This file is provided — do not modify it.
library;

import 'dart:async';
import 'dart:math';

import 'models.dart';

// ---------------------------------------------------------------------------
// SensorService
// ---------------------------------------------------------------------------

/// Simulates a home weather station with three live sensor streams.
///
/// This class is **provided** — do not modify it.
///
/// **Normal use** — create one instance and pass it to [DashboardScreen]:
/// ```dart
/// final service = SensorService();
/// ```
///
/// **Testing** — use the named constructor [SensorService.fromStreams] and
/// supply streams backed by [StreamController]s that you control.  This lets
/// you emit events at exactly the right moment in each test:
/// ```dart
/// final ctrl = StreamController<SensorReading>.broadcast();
/// final service = SensorService.fromStreams(
///   temperatureStream: ctrl.stream,
///   humidityStream:    Stream.empty(),
///   pressureStream:    Stream.empty(),
/// );
///
/// // Emit a reading:
/// ctrl.add(SensorReading(sensorId: 'temperature', value: 23.5,
///                        timestamp: DateTime.now()));
/// await tester.pump();
/// ```
class SensorService {
  /// Creates a live service that emits one reading per sensor every [interval].
  ///
  /// The default interval is 1 second; shorten it in integration tests if
  /// needed, though for unit/widget tests [SensorService.fromStreams] is
  /// preferred.
  SensorService({Duration interval = const Duration(seconds: 1)}) {
    _tempCtrl = StreamController<SensorReading>.broadcast();
    _humCtrl = StreamController<SensorReading>.broadcast();
    _presCtrl = StreamController<SensorReading>.broadcast();
    temperatureStream = _tempCtrl!.stream;
    humidityStream = _humCtrl!.stream;
    pressureStream = _presCtrl!.stream;
    _timer = Timer.periodic(interval, _emit);
  }

  /// Creates a service backed by pre-built streams.
  ///
  /// Use this in widget tests so you control exactly when events arrive.
  /// The service's [dispose] method is a no-op for this constructor — close
  /// the [StreamController]s yourself in `tearDown`.
  SensorService.fromStreams({
    required this.temperatureStream,
    required this.humidityStream,
    required this.pressureStream,
  });

  StreamController<SensorReading>? _tempCtrl;
  StreamController<SensorReading>? _humCtrl;
  StreamController<SensorReading>? _presCtrl;
  Timer? _timer;

  final _random = Random();
  double _temperature = 22.0;
  double _humidity = 55.0;
  double _pressure = 1013.0;

  /// Live stream of temperature readings (°C).
  late final Stream<SensorReading> temperatureStream;

  /// Live stream of relative-humidity readings (%).
  late final Stream<SensorReading> humidityStream;

  /// Live stream of barometric-pressure readings (hPa).
  late final Stream<SensorReading> pressureStream;

  /// Returns the stream for the sensor identified by [sensorId].
  ///
  /// [sensorId] must be `'temperature'`, `'humidity'`, or `'pressure'`.
  /// Throws [ArgumentError] for any other value.
  Stream<SensorReading> streamFor(String sensorId) => switch (sensorId) {
        'temperature' => temperatureStream,
        'humidity' => humidityStream,
        'pressure' => pressureStream,
        _ => throw ArgumentError('Unknown sensor id: $sensorId'),
      };

  void _emit(Timer _) {
    final now = DateTime.now();
    _temperature =
        (_temperature + (_random.nextDouble() - 0.5) * 0.4).clamp(15.0, 35.0);
    _humidity =
        (_humidity + (_random.nextDouble() - 0.5) * 1.0).clamp(20.0, 90.0);
    _pressure =
        (_pressure + (_random.nextDouble() - 0.5) * 0.5).clamp(980.0, 1050.0);

    _tempCtrl?.add(SensorReading(
        sensorId: 'temperature', value: _temperature, timestamp: now));
    _humCtrl?.add(SensorReading(
        sensorId: 'humidity', value: _humidity, timestamp: now));
    _presCtrl?.add(SensorReading(
        sensorId: 'pressure', value: _pressure, timestamp: now));
  }

  /// Cancels the timer and closes all stream controllers.
  ///
  /// Call this in the `dispose` method of whichever widget owns the service.
  /// Has no effect when called on a [SensorService.fromStreams] instance.
  void dispose() {
    _timer?.cancel();
    _tempCtrl?.close();
    _humCtrl?.close();
    _presCtrl?.close();
  }
}
