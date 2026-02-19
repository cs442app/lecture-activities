# Activity Report

**Name:** ___________________________

**Date:** ___________________________

## Implementation Checklist

Mark each item as complete by placing an 'x' in the brackets: [x]

- [ ] **Exercise 1**: OrderItem
- [ ] **Exercise 2**: Debug the Cart
- [ ] **Exercise 3**: CartModel
- [ ] **Exercise 4**: Shared CartModel

### Testing

- [ ] All Exercise 1 tests pass (`flutter test test/ex01_test.dart`)
- [ ] All Exercise 2 tests pass (`flutter test test/ex02_test.dart`)
- [ ] All Exercise 3 tests pass (`flutter test test/ex03_test.dart`)
- [ ] All Exercise 4 tests pass (`flutter test test/ex04_test.dart`)
- [ ] `flutter analyze` reports no issues

---

## Reflection Questions

1. **Exercise 2:** Describe the three bugs you found. For each one, explain what
   was wrong and why it caused the symptom you observed.

2. **Exercise 3:** After the refactor, `_CartScreenState` contains no state
   fields and no `setState` calls. What does it contain instead, and who is now
   responsible for triggering rebuilds?

3. **Exercises 3 & 4:** `totalPrice` in `CartModel` is a computed getter rather
   than a stored field. Why is this approach less error-prone than the manually
   maintained `_total` field in Exercise 2?

4. **Exercise 4:** Both `CartBadge` and `OrderTile` are `StatelessWidget`s that
   still update reactively. How is this possible? What is the relationship
   between `StatelessWidget` and the ability (or inability) to react to changing
   data?

---

## AI Tool Usage Disclosure

For each exercise, indicate whether AI tools were used and describe how:

**Exercise 1 (OrderItem):**

- [ ] AI used
- If yes, describe:

**Exercise 2 (Debug the Cart):**

- [ ] AI used
- If yes, describe:

**Exercise 3 (CartModel):**

- [ ] AI used
- If yes, describe:

**Exercise 4 (Shared CartModel):**

- [ ] AI used
- If yes, describe:

---

## Additional Notes

Any other observations, challenges, or insights?
