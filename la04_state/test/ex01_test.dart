import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:la04_state/ex01_menu_item.dart';
import 'package:la04_state/menu.dart';

// A fixed test item so tests don't depend on kMenu ordering.
const _pretzel = MenuItem(
  name: 'Pretzel',
  description: 'Warm, soft, and salty',
  price: 3.50,
  icon: Icons.bakery_dining,
);

Widget _wrap(Widget child) =>
    MaterialApp(home: Scaffold(body: child));

void main() {
  group('OrderItem', () {
    testWidgets('displays the item name', (tester) async {
      await tester.pumpWidget(_wrap(const OrderItem(item: _pretzel)));

      expect(find.text('Pretzel'), findsOneWidget);
    });

    testWidgets('initial quantity is 0', (tester) async {
      await tester.pumpWidget(_wrap(const OrderItem(item: _pretzel)));

      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('tapping + increments the quantity', (tester) async {
      await tester.pumpWidget(_wrap(const OrderItem(item: _pretzel)));

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('tapping + twice shows 2', (tester) async {
      await tester.pumpWidget(_wrap(const OrderItem(item: _pretzel)));

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('tapping - after + returns to 0', (tester) async {
      await tester.pumpWidget(_wrap(const OrderItem(item: _pretzel)));

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();

      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('tapping - at 0 does not go negative', (tester) async {
      await tester.pumpWidget(_wrap(const OrderItem(item: _pretzel)));

      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();

      expect(find.text('0'), findsOneWidget);
      expect(find.text('-1'), findsNothing);
    });

    testWidgets('subtotal is \$0.00 when quantity is 0', (tester) async {
      await tester.pumpWidget(_wrap(const OrderItem(item: _pretzel)));

      expect(find.text('\$0.00'), findsOneWidget);
    });

    testWidgets('subtotal updates correctly with quantity', (tester) async {
      await tester.pumpWidget(_wrap(const OrderItem(item: _pretzel)));

      // 2 × $3.50 = $7.00
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(find.text('\$7.00'), findsOneWidget);
    });
  });
}
