# Activity 4: Stateful Widgets — Snack Shop

## Learning Objectives

This activity explores Flutter's stateful widget system. You will:

- Implement a `StatefulWidget` / `State` pair and use `setState` to trigger
  rebuilds
- Diagnose and fix common `setState` bugs in an existing widget
- Extract business logic from a `State` class into a separate model object that
  extends `ChangeNotifier`
- Use `ListenableBuilder` to rebuild widgets in response to model changes,
  reducing boilerplate compared to raw `setState`
- Understand `ValueNotifier<T>` as a lightweight alternative to
  `ChangeNotifier` for single values
- Pass an externally created model into widgets so multiple parts of the tree
  can share the same state

## Background

The exercises build a **Snack Shop** — a simple in-app food-ordering screen.
The menu is fixed (six items defined in `lib/menu.dart`) and the UI lets
customers add items to a cart, see a running total, and clear their order.

Each exercise is a self-contained app in its own file. Switch between them by
changing the import in `main.dart`:

```dart
// main.dart — change this line to run a different exercise
import 'ex01_menu_item.dart';   // Exercise 1
// import 'ex02_cart.dart';     // Exercise 2
// import 'ex03_cart_model.dart'; // Exercise 3
// import 'ex04_shared_cart.dart'; // Exercise 4
```

## File Structure

```
lib/
├── main.dart                # Entry point — update the import to switch exercises
├── menu.dart                # Provided — MenuItem, CartEntry, kMenu list
├── ex01_menu_item.dart      # Exercise 1 — Implement OrderItem
├── ex02_cart.dart           # Exercise 2 — Debug CartScreen (3 bugs)
├── ex03_cart_model.dart     # Exercise 3 — Refactor CartScreen to use CartModel
├── cart_model.dart          # Exercise 3 — Implement CartModel
└── ex04_shared_cart.dart    # Exercise 4 — Implement CartBadge and OrderTile
test/
├── ex01_test.dart           # Tests for Exercise 1
├── ex02_test.dart           # Tests for Exercise 2
├── ex03_test.dart           # Tests for Exercise 3
└── ex04_test.dart           # Tests for Exercise 4
```

---

## Exercise 1: OrderItem (`lib/ex01_menu_item.dart`)

**Goal:** Implement a `StatefulWidget` that lets the user pick a quantity for
one menu item.

Open `lib/ex01_menu_item.dart`. The app shell (`SnackShopApp`, `MenuScreen`)
and the `OrderItem` class declaration are provided. Implement
`_OrderItemState`.

### What to implement

**State field**

```dart
int _quantity = 0;
```

**Methods** (each must call `setState`)

```dart
void _increment() { ... }  // increase _quantity by 1
void _decrement() { ... }  // decrease _quantity by 1, never below 0
```

**`build` method** — return a `ListTile`:

| Part       | Widget                                                                 |
| ---------- | ---------------------------------------------------------------------- |
| `leading`  | `Icon(widget.item.icon)`                                               |
| `title`    | `Text(widget.item.name)`                                               |
| `subtitle` | `Text(widget.item.description)` and price                             |
| `trailing` | `Row` (see below)                                                      |

The trailing `Row` (`mainAxisSize: MainAxisSize.min`) contains:

```
[IconButton Icons.remove] [Text '$_quantity'] [IconButton Icons.add]
[SizedBox width:8]        [Text subtotal]
```

Format the subtotal with:
```dart
'\$${(widget.item.price * _quantity).toStringAsFixed(2)}'
```

### Run and verify

Update `main.dart` to `import 'ex01_menu_item.dart'` and run the app. Each
menu item should show its own independent quantity counter. Tapping `+` on one
item should not affect the others — each `OrderItem` has its own `State`.

### Tests

```bash
flutter test test/ex01_test.dart
```

---

## Exercise 2: Debug the Cart (`lib/ex02_cart.dart`)

**Goal:** Find and fix **three bugs** in an otherwise complete `CartScreen`.

Open `lib/ex02_cart.dart`. The UI and layout are complete, but the state
management in `_CartScreenState` has three mistakes. Update `main.dart` to
import this file and run the app to observe the symptoms:

1. Tapping **Add** appears to do nothing.
2. After removing an item, the **total is wrong**.
3. After tapping **Clear Order**, the **total is wrong**.

Each symptom is caused by a distinct mistake in one of the three mutating
methods (`_addEntry`, `_removeEntry`, `_clearCart`). Read the code carefully
and fix all three.

### Hints

- Flutter only knows to rebuild a widget when `setState` is called. If state
  changes happen _without_ `setState`, the data is updated but the screen
  never refreshes.
- The `_total` field is kept in sync manually — every mutation method is
  responsible for keeping it accurate. Consider: which methods do that
  correctly, and which don't?
- After finding and fixing all three bugs, reflect on whether storing `_total`
  as a separate field is a good design. (Exercise 3 offers a better approach.)

### Tests

```bash
flutter test test/ex02_test.dart
```

All four tests should pass once all bugs are fixed.

---

## Exercise 3: CartModel (`lib/cart_model.dart` + `lib/ex03_cart_model.dart`)

**Goal:** Extract cart state into a `ChangeNotifier` model object, then
refactor `CartScreen` to use it via `ListenableBuilder`.

This exercise has two parts.

### Part A — Implement `CartModel` (`lib/cart_model.dart`)

Open `lib/cart_model.dart`. Implement every stub:

| Member            | What it should do                                          |
| ----------------- | ---------------------------------------------------------- |
| `entries`         | Return an unmodifiable view of `_entries`                  |
| `totalPrice`      | Compute the sum of `price × quantity` across all entries   |
| `totalItems`      | Compute the sum of all quantities                          |
| `quantityOf(item)`| Return the quantity for `item` in the cart, or 0           |
| `addOne(item)`    | Add/increment an entry, then call `notifyListeners()`      |
| `removeOne(item)` | Decrement or remove an entry, then call `notifyListeners()`|
| `removeEntry(i)`  | Remove the entry at index `i`, then call `notifyListeners()`|
| `clearAll()`      | Clear all entries, then call `notifyListeners()`           |

**Key insight:** `totalPrice` should be computed _on the fly_ from `_entries`,
not stored as a separate field. This eliminates the class of bug you fixed in
Exercise 2 — the total is always correct because it's derived from the source
of truth rather than maintained separately.

### Part B — Refactor `CartScreen` (`lib/ex03_cart_model.dart`)

Open `lib/ex03_cart_model.dart`. The file contains a working `setState`-based
`CartScreen` (the fixed version of Exercise 2). Refactor it in five steps as
described in the file's doc comment:

1. Add `final _model = CartModel();` to `_CartScreenState`
2. Remove `_entries` and `_total` fields
3. Replace the three mutating methods with calls to `_model`
4. Wrap the `Scaffold` in a `ListenableBuilder` listening to `_model`
5. Update `build` to read from `_model.entries` and `_model.totalPrice`

After the refactor, `_CartScreenState` should contain _no state fields_ and
_no `setState` calls_ — the model owns all state and the `ListenableBuilder`
drives all rebuilds.

### `ValueNotifier<T>`

For state that's just a single value, Dart provides `ValueNotifier<T>`, a
`ChangeNotifier` that wraps one value and automatically calls
`notifyListeners()` when `.value` is set:

```dart
final count = ValueNotifier<int>(0);
count.value++;          // automatically notifies listeners
count.value = 42;       // also notifies listeners
```

You can use it anywhere you'd use a `ChangeNotifier`:

```dart
ListenableBuilder(
  listenable: count,
  builder: (context, _) => Text('${count.value}'),
)
```

`CartModel` uses a full `ChangeNotifier` because it manages several related
values together. When you have just one value to track, `ValueNotifier` is
simpler and avoids the need to write a custom class.

### Tests

```bash
flutter test test/ex03_test.dart
```

This file contains both unit tests for `CartModel` and widget tests for the
refactored `CartScreen`.

---

## Exercise 4: Shared CartModel (`lib/ex04_shared_cart.dart`)

**Goal:** Pass a single `CartModel` instance into multiple widgets so they
all react to the same shared state.

Open `lib/ex04_shared_cart.dart`. The `SnackShopApp` root already creates a
`CartModel` and passes it to `MenuScreen`. Implement the two TODO widgets.

### Part A — `CartBadge`

`CartBadge` is a shopping-cart icon that shows a badge with the total item
count. It is placed in the `AppBar`.

Use `ListenableBuilder` to rebuild when `cart` changes. Inside the builder,
use Flutter's `Badge` widget:

```dart
Badge(
  label: Text('${cart.totalItems}'),
  isLabelVisible: cart.totalItems > 0,
  child: const Icon(Icons.shopping_cart),
)
```

Wrap the `Badge` in a `Padding` (horizontal inset of 16) so it doesn't crowd
the AppBar edge. Once implemented, uncomment the `CartBadge(cart: cart)` line
in `MenuScreen.build`.

### Part B — `OrderTile`

`OrderTile` replaces the read-only menu rows from earlier exercises with
quantity controls that read from and write to the shared `CartModel`.

Use `ListenableBuilder` to rebuild when `cart` changes. Inside the builder:

1. Call `cart.quantityOf(item)` to get the current quantity for this item.
2. Build a `ListTile`:

| Part       | Content                                                               |
| ---------- | --------------------------------------------------------------------- |
| `leading`  | `Icon(item.icon)`                                                     |
| `title`    | `Text(item.name)`                                                     |
| `subtitle` | `Text(item.description)`                                              |
| `trailing` | `Row` with −/quantity/+ controls and the item price                   |

The trailing row:

```
[IconButton Icons.remove] [Text '$qty'] [IconButton Icons.add]
[SizedBox width:8]        [Text '\$${item.price.toStringAsFixed(2)}']
```

- The `−` button calls `cart.removeOne(item)`. Disable it (`onPressed: null`)
  when `qty == 0`.
- The `+` button calls `cart.addOne(item)`.

### Why this matters

Notice that `CartBadge` and `OrderTile` are both **`StatelessWidget`**s,
yet they update reactively. This is the payoff of a proper model layer: once
the model owns the state, individual widgets don't need to be stateful. The
`ListenableBuilder` handles the rebuild, and both widgets always show
consistent data because they're reading from the same `CartModel` instance.

### Tests

```bash
flutter test test/ex04_test.dart
```

The `Shared CartModel` group verifies that tapping `+` on an `OrderTile`
updates both the tile's quantity display and the `CartBadge` count.

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
flutter test test/ex04_test.dart
```

Run the analyzer:

```bash
flutter analyze
```

Fix any issues before submitting.

---

## Submission

1. Complete all four exercises
2. Ensure all tests pass (`flutter test`)
3. Ensure no analyzer issues (`flutter analyze`)
4. Complete the `REPORT.md` self-evaluation
5. Commit and push your changes
