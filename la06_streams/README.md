# Activity 6: Streams — Weather Station

## Learning Objectives

This activity explores Dart streams and stream-driven Flutter UIs. You will:

- Use `StreamBuilder` to rebuild a widget automatically every time a stream
  emits a new value
- Use `StreamSubscription` (`.listen()`) to accumulate stream events into a
  list imperatively, and cancel the subscription in `dispose` to prevent
  memory leaks
- Apply stream transformation methods (`.where()` and `.map()`) to filter and
  convert the events a stream produces before consuming them
- *(Bonus)* Write an `async*` generator function that creates a stream from
  scratch using `yield`

## Background

### Streams vs Futures

A `Future<T>` produces **one** value (or one error) and then it is done —
like a delivery that arrives once. A `Stream<T>` produces **zero or more**
values over time, like a live feed that keeps sending updates until it closes.

```
Future:  ───────────────── value ✓
Stream:  ── v1 ── v2 ── v3 ── v4 ── ... ──| (closes)
```

Everything you know about `async`/`await` still applies inside a stream
listener — streams just keep delivering instead of stopping after one event.

### Hot streams and broadcast streams

In this activity the provided `SensorService` exposes **broadcast streams**
(created with `StreamController.broadcast()`). A broadcast stream is "hot":
it emits events regardless of whether anyone is listening, and multiple
listeners can subscribe to the same stream simultaneously.

This matters for your Dashboard → History navigation: when you pass
`widget.service.streamFor(config.id)` to `HistoryScreen`, both the
`StreamBuilder` in the dashboard tile *and* the `StreamSubscription` in the
history screen listen to the same live stream at the same time.

### StreamBuilder

`StreamBuilder` is the stream equivalent of `FutureBuilder`. It rebuilds its
subtree every time the stream emits, and it exposes a `snapshot` with a
`connectionState` field:

| `connectionState`         | Meaning                                          |
|---------------------------|--------------------------------------------------|
| `ConnectionState.waiting` | Subscribed, but no event has arrived yet         |
| `ConnectionState.active`  | The stream has emitted at least one event        |
| `ConnectionState.done`    | The stream has closed                            |

When `connectionState` is `active`, `snapshot.hasData` is `true` and
`snapshot.data` holds the most recent value.

```dart
StreamBuilder<SensorReading>(
  stream: myStream,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Text('--');
    }
    if (snapshot.hasData) {
      return Text('${snapshot.data!.value}');
    }
    return const Text('?'); // error or done
  },
)
```

### StreamSubscription

When you want to **accumulate** events into a list (or update state
imperatively), use `.listen()` instead of `StreamBuilder`:

```dart
_subscription = myStream.listen((event) {
  setState(() => _items.add(event));
});
```

`.listen()` returns a `StreamSubscription` object. You must cancel it when
the widget is disposed — otherwise the listener holds a reference to the
`State` object and future events will call `setState` on a dead widget:

```dart
@override
void dispose() {
  _subscription?.cancel(); // always cancel before super.dispose()
  super.dispose();
}
```

### Stream transformations

Streams support functional transformation methods that return a **new stream**
without modifying the original:

| Method         | What it does                                                    |
|----------------|-----------------------------------------------------------------|
| `.where(pred)` | Drops events for which the predicate returns `false`            |
| `.map(fn)`     | Converts each event using `fn`, producing a stream of new type  |

These can be chained:

```dart
final alertStream = rawStream
    .where((r) => r.value > threshold) // keep only high readings
    .map((r) => Alert(value: r.value, ...)); // convert to Alert
```

The result (`alertStream`) is just another `Stream` — you can pass it to a
`StreamBuilder` or call `.listen()` on it as usual.

## File Structure

```
lib/
├── main.dart               # Entry point — provided, do not modify
├── models.dart             # Provided — SensorReading, SensorConfig, Alert, kSensors
├── sensor_service.dart     # Provided — SensorService with three live streams
├── dashboard_screen.dart   # Exercise 1 — implement the TODOs
├── history_screen.dart     # Exercise 2 (+ Bonus) — implement the TODOs
└── alert_screen.dart       # Exercise 3 — implement the TODOs
test/
├── ex01_test.dart          # Tests for Exercise 1 (7 tests)
├── ex02_test.dart          # Tests for Exercise 2 (6 tests)
├── ex03_test.dart          # Tests for Exercise 3 (6 tests)
└── bonus_test.dart         # Tests for the Bonus exercise (4 tests)
```

The app flow:

```
DashboardScreen ──[tap tile]──► HistoryScreen
      │
      └──[tap bell icon]──► AlertScreen
```

---

## Exercise 1: StreamBuilder (`lib/dashboard_screen.dart`)

**Goal:** Display live sensor readings on three tiles using `StreamBuilder`.

### What to implement

**TODO 1a** — In `build`, replace the `Placeholder` body with a `ListView`
that maps `kSensors` to one `_buildTile` widget each:

```dart
ListView(
  padding: const EdgeInsets.all(16),
  children: kSensors.map(_buildTile).toList(),
)
```

**TODO 1b + 1c** — Inside `_buildTile`, replace the `Placeholder(fallbackHeight: 24)`
with a `StreamBuilder<SensorReading>` that listens to
`widget.service.streamFor(config.id)`:

| Condition                  | What to display                                             |
|----------------------------|-------------------------------------------------------------|
| `ConnectionState.waiting`  | `_buildValue('--', config.unit)`                            |
| `snapshot.hasData`         | `_buildValue(snapshot.data!.value.toStringAsFixed(1), config.unit)` |
| otherwise (error / done)   | `_buildValue('?', config.unit)`                             |

The `StreamBuilder` replaces the `Placeholder` that is currently the last
child of the tile's inner `Column`.

**TODO 1d** — Replace `onTap: null` with a callback that pushes `HistoryScreen`,
passing the stream for this sensor and its config:

```dart
onTap: () => Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => HistoryScreen(
      stream: widget.service.streamFor(config.id),
      config: config,
    ),
  ),
),
```

### Run and verify

Run the app. You should see three tiles — **Temperature**, **Humidity**,
**Pressure** — each showing `--` for a brief moment before switching to a live
value that updates every second. Tapping any tile should navigate to a history
screen (it will show a `Placeholder` until Exercise 2).

### Tests

```bash
flutter test test/ex01_test.dart
```

---

## Exercise 2: StreamSubscription (`lib/history_screen.dart`)

**Goal:** Accumulate readings from the passed-in stream into a list and display
them as they arrive, with the most recent reading at the top.

### What to implement

**TODO 2a** — Declare two fields in `_HistoryScreenState`:

```dart
final List<SensorReading> _readings = [];
StreamSubscription<SensorReading>? _subscription;
```

**TODO 2b** — Subscribe in `initState`:

```dart
@override
void initState() {
  super.initState();
  _subscription = widget.stream.listen((reading) {
    setState(() => _readings.insert(0, reading));
  });
}
```

`insert(0, reading)` places each new reading at position 0 so the most
recent entry always appears at the top of the list.

**TODO 2c** — Cancel in `dispose`:

```dart
@override
void dispose() {
  _subscription?.cancel();
  super.dispose();
}
```

**TODO 2d** — Replace the `Placeholder` body:

```dart
body: _readings.isEmpty
    ? const Center(child: Text('No readings yet.'))
    : ListView.builder(
        itemCount: _readings.length,
        itemBuilder: (context, index) {
          final reading = _readings[index];
          return ListTile(
            leading: Icon(widget.config.icon),
            title: Text(
              '${reading.value.toStringAsFixed(1)} ${widget.config.unit}',
            ),
            subtitle: Text(_formatTime(reading.timestamp)),
          );
        },
      ),
```

### Run and verify

Tap a dashboard tile. The history screen should initially show
*"No readings yet."*, then fill with entries as the sensor emits. Navigate
back — the dashboard tiles continue updating. Navigate to history again — it
starts fresh (the widget is re-created, so the list resets; that is expected).

### Tests

```bash
flutter test test/ex02_test.dart
```

---

## Exercise 3: Stream transformations (`lib/alert_screen.dart`)

**Goal:** Build a transformation pipeline using `.where()` and `.map()` that
converts raw sensor readings into `Alert` objects, then accumulate and display
the resulting alerts. Rebuild the pipeline whenever the sensor or threshold
changes.

The screen's filter controls (dropdown and text field) are already provided.

### What to implement

**TODO 3a** — Declare two fields:

```dart
final List<Alert> _alerts = [];
StreamSubscription<Alert>? _subscription;
```

**TODO 3b** — In `initState`, call `_updateAlertStream()` to set up the
initial subscription:

```dart
@override
void initState() {
  super.initState();
  _updateAlertStream();
}
```

**TODO 3c** — In `dispose`, cancel the subscription:

```dart
@override
void dispose() {
  _subscription?.cancel();
  _thresholdController.dispose();
  super.dispose();
}
```

**TODO 3d** — Implement `_updateAlertStream()`:

```dart
void _updateAlertStream() {
  _subscription?.cancel();  // step 1: stop the old listener
  _alerts = [];             // step 2: clear stale alerts from the UI

  // step 3: build the transformation pipeline
  final alertStream = widget.service
      .streamFor(_selectedSensor.id)
      .where((reading) => reading.value > _threshold)
      .map((reading) => Alert(
            sensorLabel: _selectedSensor.label,
            value:       reading.value,
            unit:        _selectedSensor.unit,
            threshold:   _threshold,
            timestamp:   reading.timestamp,
          ));

  // step 4: subscribe
  _subscription = alertStream.listen((alert) {
    setState(() => _alerts.insert(0, alert));
  });
}
```

**TODO 3e** — In `DropdownButtonFormField.onChanged`, update the selected
sensor and rebuild the pipeline:

```dart
onChanged: (config) {
  if (config == null) return;
  setState(() => _selectedSensor = config);
  _updateAlertStream();
},
```

**TODO 3f** — In the `Apply` button's `onPressed`, update the threshold and
rebuild the pipeline:

```dart
onPressed: () {
  final value = double.tryParse(_thresholdController.text);
  if (value == null) return;
  setState(() => _threshold = value);
  _updateAlertStream();
},
```

**TODO 3g** — Replace the `Placeholder` with the alert list:

```dart
_alerts.isEmpty
    ? const Expanded(child: Center(child: Text('No alerts yet.')))
    : Expanded(
        child: ListView.builder(
          itemCount: _alerts.length,
          itemBuilder: (context, index) {
            final alert = _alerts[index];
            return ListTile(
              leading: const Icon(Icons.warning_amber, color: Colors.orange),
              title: Text(
                '${alert.sensorLabel}: '
                '${alert.value.toStringAsFixed(1)} ${alert.unit}',
              ),
              subtitle: Text(
                '${_formatTime(alert.timestamp)} — '
                'above ${alert.threshold.toStringAsFixed(1)} ${alert.unit}',
              ),
            );
          },
        ),
      ),
```

### Run and verify

Open the alert screen via the bell icon on the dashboard. Set the temperature
threshold just below the current reading and tap **Apply** — alerts should
begin appearing. Switch the sensor to Humidity; the list should clear and now
only respond to humidity readings above the threshold.

### Tests

```bash
flutter test test/ex03_test.dart
```

---

## Bonus: `async*` and `yield` (`lib/history_screen.dart`)

The function `replayReadings` near the top of `lib/history_screen.dart` is a
stub that currently throws `UnimplementedError`. Implement it using Dart's
`async*` / `yield` syntax.

### Background: what is `async*`?

An `async*` function is a **generator** — it produces a `Stream` instead of a
single value. Where a normal `async` function uses `return` once, an `async*`
function uses `yield` to emit multiple values, and the stream closes
automatically when the function returns.

Inside an `async*` function you can still use `await`, exactly as in a normal
`async` function. This lets you introduce delays between yields:

```dart
Stream<int> countDown(int from) async* {
  for (int i = from; i >= 0; i--) {
    await Future.delayed(const Duration(seconds: 1));
    yield i;
  }
} // stream closes here — the for loop has finished
```

Calling `countDown(3)` returns a `Stream<int>` that emits `3`, `2`, `1`, `0`
with one-second gaps, then closes.

Compare this to the `StreamController` approach in `SensorService`:
- `StreamController` is **imperative** — you call `add()` from outside (e.g.
  from a `Timer`) and `close()` when done.
- `async*` is **declarative** — the stream's logic lives entirely inside the
  function body and closes naturally when the function returns.

For "produce a fixed sequence of values" patterns, `async*` is cleaner.

### What to implement

Replace the `throw UnimplementedError()` stub with an `async*` body:

```dart
Stream<SensorReading> replayReadings(
  List<SensorReading> history, {
  Duration interval = const Duration(milliseconds: 500),
}) async* {
  for (final reading in history) {
    await Future.delayed(interval);
    yield reading;
  }
}
```

Adding `async*` between `)` and `{` in the function signature is all it takes
to turn a regular function into a generator. The `for` loop, `await`, and
`yield` do the rest.

### Tests

```bash
flutter test test/bonus_test.dart
```

---

## Verification

Run all tests:

```bash
flutter test
```

Run tests for a single exercise:

```bash
flutter test test/ex01_test.dart
flutter test test/ex02_test.dart
flutter test test/ex03_test.dart
flutter test test/bonus_test.dart   # optional
```

Run the analyzer:

```bash
flutter analyze
```

Fix any issues before submitting.

---

## Submission

1. Complete all three exercises (and optionally the bonus)
2. Ensure all required tests pass (`flutter test test/ex01_test.dart test/ex02_test.dart test/ex03_test.dart`)
3. Ensure no analyzer issues (`flutter analyze`)
4. Complete the `REPORT.md` self-evaluation
5. Commit and push your changes
