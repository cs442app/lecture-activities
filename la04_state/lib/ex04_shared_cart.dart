import 'package:flutter/material.dart';

import 'menu.dart';
import 'cart_model.dart';

// Run this exercise by updating main.dart to:
//   import 'ex04_shared_cart.dart';

/// App root — creates the [CartModel] and passes it to the rest of the tree.
///
/// Because the model is created here (above both the AppBar badge and the menu
/// list), both widgets can share the exact same instance and will always show
/// consistent state.
class SnackShopApp extends StatelessWidget {
  const SnackShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = CartModel();
    return MaterialApp(
      title: 'Snack Shop',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      home: MenuScreen(cart: cart),
    );
  }
}

/// The main menu screen.
///
/// Receives [cart] from above and passes it down to both [CartBadge] (in the
/// [AppBar]) and each [OrderTile] (in the [body]).  Both widgets react to the
/// same model, so they always agree on the current cart contents.
class MenuScreen extends StatelessWidget {
  final CartModel cart;

  const MenuScreen({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Snack Shop'),
        actions: [
          // TODO: Uncomment once CartBadge is implemented.
          // CartBadge(cart: cart),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              children: kMenu
                  .map((item) => OrderTile(item: item, cart: cart))
                  .toList(),
            ),
          ),
          // Cart total footer
          const Divider(),
          ListenableBuilder(
            listenable: cart,
            builder: (context, _) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Text(
                    'Total: \$${cart.totalPrice.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: cart.totalItems > 0
                        ? () => cart.clearAll()
                        : null,
                    child: const Text('Clear Order'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Shows a shopping-cart icon with a badge displaying the total item count.
///
/// TODO: Implement this widget.
///
/// Use a [ListenableBuilder] to rebuild whenever [cart] changes.
///
/// Inside the builder, read [cart.totalItems] and display it as a badge on a
/// shopping-cart icon.  Flutter's built-in [Badge] widget makes this easy:
///
///   Badge(
///     label: Text('${cart.totalItems}'),
///     isLabelVisible: cart.totalItems > 0,
///     child: const Icon(Icons.shopping_cart),
///   )
///
/// Wrap the [Badge] in a [Padding] with horizontal insets of 16 so it doesn't
/// crowd the edge of the AppBar.
///
/// Note: this is a [StatelessWidget] — all reactive behavior comes from
/// [ListenableBuilder], not from [setState].
class CartBadge extends StatelessWidget {
  final CartModel cart;

  const CartBadge({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace Placeholder with a ListenableBuilder + Badge.
    return const Placeholder();
  }
}

/// Displays a menu item with quantity controls that read from and write to the
/// shared [CartModel].
///
/// TODO: Implement this widget.
///
/// Use a [ListenableBuilder] to rebuild whenever [cart] changes.
///
/// Inside the builder, call [cart.quantityOf(item)] to get the current
/// quantity, then build a [ListTile]:
///
///   leading  : Icon(item.icon)
///   title    : item.name
///   subtitle : item.description
///   trailing : Row(mainAxisSize: MainAxisSize.min) with:
///                IconButton(Icons.remove) — calls cart.removeOne(item)
///                                          disable (onPressed: null) when qty == 0
///                Text('$qty')
///                IconButton(Icons.add)    — calls cart.addOne(item)
///                SizedBox(width: 8)
///                Text('\$${item.price.toStringAsFixed(2)}')
///
/// Note: this is a [StatelessWidget] — once the model owns the state, the
/// widget itself needs no state of its own.
class OrderTile extends StatelessWidget {
  final MenuItem item;
  final CartModel cart;

  const OrderTile({super.key, required this.item, required this.cart});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace Placeholder with a ListenableBuilder + ListTile.
    return const Placeholder();
  }
}
