import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:la04_state/ex02_cart.dart';

// All four tests here describe the CORRECT behavior of CartScreen.
// They will fail while the bugs are present and pass once all three are fixed.
//
// kMenu[0] = Pretzel at $3.50

void main() {
  group('CartScreen (Exercise 2 — fixed)', () {
    testWidgets('tapping Add shows a cart entry', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CartScreen()));

      // Before: no remove buttons (cart empty)
      expect(find.byIcon(Icons.remove_circle_outline), findsNothing);

      await tester.tap(find.text('Add').first);
      await tester.pump();

      // After: one entry visible in the cart
      expect(find.byIcon(Icons.remove_circle_outline), findsOneWidget);
    });

    testWidgets('total updates when an item is added', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CartScreen()));

      expect(find.text('Total: \$0.00'), findsOneWidget);

      // Add Pretzel ($3.50)
      await tester.tap(find.text('Add').first);
      await tester.pump();

      expect(find.text('Total: \$3.50'), findsOneWidget);
    });

    testWidgets('total updates when an item is removed', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CartScreen()));

      await tester.tap(find.text('Add').first); // Add Pretzel
      await tester.pump();

      await tester.tap(find.byIcon(Icons.remove_circle_outline));
      await tester.pump();

      expect(find.text('Total: \$0.00'), findsOneWidget);
    });

    testWidgets('Clear Order empties cart and resets total', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CartScreen()));

      await tester.tap(find.text('Add').first); // Add Pretzel
      await tester.pump();

      await tester.tap(find.text('Clear Order'));
      await tester.pump();

      expect(find.text('Total: \$0.00'), findsOneWidget);
      expect(find.text('Nothing ordered yet'), findsOneWidget);
    });
  });
}
