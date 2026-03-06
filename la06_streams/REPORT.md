# Activity Report

**Name:** ___________________________

**Date:** ___________________________

## Implementation Checklist

Mark each item as complete by placing an 'x' in the brackets: [x]

- [ ] **Exercise 1**: StreamBuilder (DashboardScreen)
- [ ] **Exercise 2**: StreamSubscription (HistoryScreen)
- [ ] **Exercise 3**: Stream transformations (AlertScreen)
- [ ] **Bonus** (optional): async* / yield (replayReadings)

### Testing

- [ ] All Exercise 1 tests pass (`flutter test test/ex01_test.dart`)
- [ ] All Exercise 2 tests pass (`flutter test test/ex02_test.dart`)
- [ ] All Exercise 3 tests pass (`flutter test test/ex03_test.dart`)
- [ ] `flutter analyze` reports no issues

---

## Reflection Questions

1. **Exercise 1:** `StreamBuilder` and `FutureBuilder` are both driven by a
   snapshot with a `connectionState` field. What states can a `StreamBuilder`
   enter that a `FutureBuilder` cannot, and why? What does this tell you about
   the fundamental difference between a `Stream` and a `Future`?

2. **Exercise 2:** You stored the `StreamSubscription` in a field and cancelled
   it in `dispose`. What would happen if you skipped the `cancel()` call?
   Describe a concrete scenario — what error (if any) would appear, and when?

3. **Exercise 2 vs Exercise 1:** Both exercises display sensor data, but one
   uses `StreamBuilder` and the other uses `StreamSubscription` + `setState`.
   What is the key difference in the *behavior* you wanted in each screen, and
   why does that difference make one approach more natural than the other?

4. **Exercise 3:** `_updateAlertStream` cancels the old subscription and
   creates a new one from scratch every time the sensor or threshold changes.
   Why is it necessary to cancel the old subscription before creating the new
   one? What would go wrong if you only created the new subscription without
   cancelling the old one?

5. **Exercise 3:** The `.where()` and `.map()` calls in `_updateAlertStream`
   do not modify `widget.service.streamFor(...)` — they return a new stream.
   Explain what this means for the underlying broadcast stream in `SensorService`.
   Is it affected by the transformation pipeline? Could two different
   `AlertScreen` instances with different thresholds both work correctly at the
   same time?

---

## AI Tool Usage Disclosure

For each exercise, indicate whether AI tools were used and describe how:

**Exercise 1 (StreamBuilder — DashboardScreen):**

- [ ] AI used
- If yes, describe:

**Exercise 2 (StreamSubscription — HistoryScreen):**

- [ ] AI used
- If yes, describe:

**Exercise 3 (Stream transformations — AlertScreen):**

- [ ] AI used
- If yes, describe:

**Bonus (async* / yield):**

- [ ] AI used
- If yes, describe:

---

## Additional Notes

Any other observations, challenges, or insights?
