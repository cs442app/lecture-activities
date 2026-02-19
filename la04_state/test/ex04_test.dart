import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:la04_state/cart_model.dart';
import 'package:la04_state/ex04_shared_cart.dart';
import 'package:la04_state/menu.dart';

void main() {
  group('CartBadge', () {
    testWidgets('shows a shopping cart icon', (tester) async {
      final cart = CartModel();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(actions: [CartBadge(cart: cart)]),
            body: const SizedBox(),
          ),
        ),
      );
      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
    });

    testWidgets('badge count updates when an item is added to the model',
        (tester) async {
      final cart = CartModel();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(actions: [CartBadge(cart: cart)]),
            body: const SizedBox(),
          ),
        ),
      );

      cart.addOne(kMenu[0]);
      await tester.pump();

      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('badge count reflects multiple items', (tester) async {
      final cart = CartModel();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(actions: [CartBadge(cart: cart)]),
            body: const SizedBox(),
          ),
        ),
      );

      cart.addOne(kMenu[0]);
      cart.addOne(kMenu[0]);
      cart.addOne(kMenu[1]);
      await tester.pump();

      expect(find.text('3'), findsOneWidget);
    });
  });

  group('OrderTile', () {
    testWidgets('shows item name', (tester) async {
      final cart = CartModel();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: OrderTile(item: kMenu[0], cart: cart)),
        ),
      );
      expect(find.text(kMenu[0].name), findsOneWidget);
    });

    testWidgets('initial quantity is 0', (tester) async {
      final cart = CartModel();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: OrderTile(item: kMenu[0], cart: cart)),
        ),
      );
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('tapping + increments quantity display and updates model',
        (tester) async {
      final cart = CartModel();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: OrderTile(item: kMenu[0], cart: cart)),
        ),
      );

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(find.text('1'), findsOneWidget);
      expect(cart.totalItems, 1);
    });
  });

  group('Shared CartModel (CartBadge + OrderTile)', () {
    testWidgets(
        'tapping + in OrderTile updates both the tile quantity and the badge',
        (tester) async {
      final cart = CartModel();
      await tester.pumpWidget(MaterialApp(home: MenuScreen(cart: cart)));

      // Tap the + button on the first OrderTile (Pretzel)
      await tester.tap(find.byIcon(Icons.add).first);
      await tester.pump();

      // The tile shows quantity 1 and the badge also shows 1
      expect(find.text('1'), findsNWidgets(2));
    });

    testWidgets('footer total reflects model state', (tester) async {
      final cart = CartModel();
      await tester.pumpWidget(MaterialApp(home: MenuScreen(cart: cart)));

      expect(find.text('Total: \$0.00'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.add).first); // Pretzel $3.50
      await tester.pump();

      expect(find.text('Total: \$3.50'), findsOneWidget);
    });
  });
}
