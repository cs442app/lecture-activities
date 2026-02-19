# Activity Report

**Name:** ___________________________

**Date:** ___________________________

## Implementation Checklist

Mark each item as complete by placing an 'x' in the brackets: [x]

### Exercise 1: OrderItem

- [ ] `_quantity` field declared in `_OrderItemState`
- [ ] `_increment` calls `setState` to increase `_quantity`
- [ ] `_decrement` calls `setState` and never lets `_quantity` go below 0
- [ ] `build` returns a `ListTile` with leading icon, title, subtitle, and trailing row
- [ ] Trailing row shows the current quantity and an accurate subtotal
- [ ] Each `OrderItem` maintains its own independent quantity

### Exercise 2: Debug the Cart

- [ ] Bug 1 identified and fixed (`_addEntry`)
- [ ] Bug 2 identified and fixed (`_removeEntry`)
- [ ] Bug 3 identified and fixed (`_clearCart`)
- [ ] Described each bug in the reflection below

### Exercise 3: CartModel

- [ ] `entries` getter returns an unmodifiable view of the internal list
- [ ] `totalPrice` is computed from entries (not stored as a field)
- [ ] `totalItems` is computed from entries
- [ ] `quantityOf` returns the correct quantity for any item
- [ ] `addOne` correctly adds or increments, and calls `notifyListeners`
- [ ] `removeOne` correctly decrements or removes, and calls `notifyListeners`
- [ ] `removeEntry` removes by index and calls `notifyListeners`
- [ ] `clearAll` empties the list and calls `notifyListeners`
- [ ] `_CartScreenState` no longer has `_entries` or `_total` fields
- [ ] `_CartScreenState` no longer calls `setState`
- [ ] `build` is wrapped in `ListenableBuilder`

### Exercise 4: Shared CartModel

- [ ] `CartBadge` uses `ListenableBuilder` and shows the correct item count
- [ ] Badge is hidden (or shows 0) when the cart is empty
- [ ] `CartBadge` uncommented in `MenuScreen.build`
- [ ] `OrderTile` uses `ListenableBuilder` and reads quantity from `cart.quantityOf`
- [ ] `OrderTile` `+` button calls `cart.addOne`
- [ ] `OrderTile` `−` button calls `cart.removeOne` and is disabled at quantity 0
- [ ] Both `CartBadge` and `OrderTile` are `StatelessWidget`s

### Testing

- [ ] All Exercise 1 tests pass (`flutter test test/ex01_test.dart`)
- [ ] All Exercise 2 tests pass (`flutter test test/ex02_test.dart`)
- [ ] All Exercise 3 tests pass (`flutter test test/ex03_test.dart`)
- [ ] All Exercise 4 tests pass (`flutter test test/ex04_test.dart`)
- [ ] `flutter analyze` reports no issues

---

## Reflection Questions

1. **Exercise 2:** Describe the three bugs you found. For each one, explain
   what was wrong and why it caused the symptom you observed.

   _Your answer:_

2. **Exercise 3:** After the refactor, `_CartScreenState` contains no state
   fields and no `setState` calls. What does it contain instead, and who is
   now responsible for triggering rebuilds?

   _Your answer:_

3. **Exercises 3 & 4:** `totalPrice` in `CartModel` is a computed getter
   rather than a stored field. Why is this approach less error-prone than the
   manually maintained `_total` field in Exercise 2?

   _Your answer:_

4. **Exercise 4:** Both `CartBadge` and `OrderTile` are `StatelessWidget`s
   that still update reactively. How is this possible? What is the relationship
   between `StatelessWidget` and the ability (or inability) to react to
   changing data?

   _Your answer:_

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
