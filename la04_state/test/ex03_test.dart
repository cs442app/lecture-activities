import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:la04_state/cart_model.dart';
import 'package:la04_state/ex03_cart_model.dart';
import 'package:la04_state/menu.dart';

void main() {
  // ── CartModel unit tests ──────────────────────────────────────────────────
  group('CartModel', () {
    test('starts empty', () {
      final model = CartModel();
      expect(model.entries, isEmpty);
      expect(model.totalPrice, 0.0);
      expect(model.totalItems, 0);
    });

    test('addOne adds a new entry with quantity 1', () {
      final model = CartModel();
      model.addOne(kMenu[0]);
      expect(model.entries.length, 1);
      expect(model.entries.first.item, kMenu[0]);
      expect(model.entries.first.quantity, 1);
    });

    test('addOne increments quantity for an existing item', () {
      final model = CartModel();
      model.addOne(kMenu[0]);
      model.addOne(kMenu[0]);
      expect(model.entries.length, 1);
      expect(model.entries.first.quantity, 2);
    });

    test('addOne for different items creates separate entries', () {
      final model = CartModel();
      model.addOne(kMenu[0]);
      model.addOne(kMenu[1]);
      expect(model.entries.length, 2);
    });

    test('totalPrice is computed from entries', () {
      final model = CartModel();
      model.addOne(kMenu[0]); // Pretzel $3.50
      model.addOne(kMenu[0]); // Pretzel again → 2 × $3.50
      model.addOne(kMenu[1]); // Nachos  $5.00
      // Expected: 2 × 3.50 + 5.00 = 12.00
      expect(model.totalPrice, closeTo(12.0, 0.001));
    });

    test('totalItems sums quantities across all entries', () {
      final model = CartModel();
      model.addOne(kMenu[0]);
      model.addOne(kMenu[0]);
      model.addOne(kMenu[1]);
      expect(model.totalItems, 3);
    });

    test('quantityOf returns correct count', () {
      final model = CartModel();
      model.addOne(kMenu[0]);
      model.addOne(kMenu[0]);
      expect(model.quantityOf(kMenu[0]), 2);
      expect(model.quantityOf(kMenu[1]), 0);
    });

    test('removeOne decrements quantity', () {
      final model = CartModel();
      model.addOne(kMenu[0]);
      model.addOne(kMenu[0]);
      model.removeOne(kMenu[0]);
      expect(model.entries.first.quantity, 1);
    });

    test('removeOne removes entry when quantity reaches zero', () {
      final model = CartModel();
      model.addOne(kMenu[0]);
      model.removeOne(kMenu[0]);
      expect(model.entries, isEmpty);
    });

    test('removeOne does nothing when item is not in cart', () {
      final model = CartModel();
      model.removeOne(kMenu[0]); // should not throw
      expect(model.entries, isEmpty);
    });

    test('removeEntry removes the entry at the given index', () {
      final model = CartModel();
      model.addOne(kMenu[0]);
      model.addOne(kMenu[1]);
      model.removeEntry(0);
      expect(model.entries.length, 1);
      expect(model.entries.first.item, kMenu[1]);
    });

    test('clearAll empties the cart', () {
      final model = CartModel();
      model.addOne(kMenu[0]);
      model.addOne(kMenu[1]);
      model.clearAll();
      expect(model.entries, isEmpty);
      expect(model.totalPrice, 0.0);
      expect(model.totalItems, 0);
    });

    test('addOne calls notifyListeners', () {
      final model = CartModel();
      var notified = false;
      model.addListener(() => notified = true);
      model.addOne(kMenu[0]);
      expect(notified, isTrue);
    });

    test('removeOne calls notifyListeners', () {
      final model = CartModel();
      model.addOne(kMenu[0]);
      var notified = false;
      model.addListener(() => notified = true);
      model.removeOne(kMenu[0]);
      expect(notified, isTrue);
    });

    test('removeEntry calls notifyListeners', () {
      final model = CartModel();
      model.addOne(kMenu[0]);
      var notified = false;
      model.addListener(() => notified = true);
      model.removeEntry(0);
      expect(notified, isTrue);
    });

    test('clearAll calls notifyListeners', () {
      final model = CartModel();
      model.addOne(kMenu[0]);
      var notified = false;
      model.addListener(() => notified = true);
      model.clearAll();
      expect(notified, isTrue);
    });
  });

  // ── CartScreen widget tests ───────────────────────────────────────────────
  group('CartScreen (Exercise 3)', () {
    testWidgets('adding an item via the Add button updates the cart',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CartScreen()));

      expect(find.text('Total: \$0.00'), findsOneWidget);

      await tester.tap(find.text('Add').first); // Add Pretzel ($3.50)
      await tester.pump();

      expect(find.text('Total: \$3.50'), findsOneWidget);
    });

    testWidgets('Clear Order resets total to \$0.00', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CartScreen()));

      await tester.tap(find.text('Add').first);
      await tester.pump();

      await tester.tap(find.text('Clear Order'));
      await tester.pump();

      expect(find.text('Total: \$0.00'), findsOneWidget);
      expect(find.text('Nothing ordered yet'), findsOneWidget);
    });
  });
}
