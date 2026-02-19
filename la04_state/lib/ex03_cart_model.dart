import 'package:flutter/material.dart';

import 'menu.dart';
import 'cart_model.dart';

// Run this exercise by updating main.dart to:
//   import 'ex03_cart_model.dart';

class SnackShopApp extends StatelessWidget {
  const SnackShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snack Shop',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      home: const CartScreen(),
    );
  }
}

/// The cart screen, refactored to use [CartModel] instead of raw [setState].
///
/// Your starting point is a fully working [setState]-based implementation
/// (the corrected version of Exercise 2). Refactor it in place:
///
///   Step 1 — Create a [CartModel] instance in [_CartScreenState]:
///              final _model = CartModel();
///
///   Step 2 — Remove the [_entries] and [_total] fields; [CartModel] owns them.
///
///   Step 3 — Delete [_addEntry], [_removeEntry], and [_clearCart], replacing
///             each call site with the equivalent [CartModel] method.
///
///   Step 4 — Wrap the [Scaffold] in a [ListenableBuilder] that listens to
///             [_model] and rebuilds whenever the cart changes:
///
///               @override
///               Widget build(BuildContext context) {
///                 return ListenableBuilder(
///                   listenable: _model,
///                   builder: (context, _) {
///                     return Scaffold( ... );
///                   },
///                 );
///               }
///
///   Step 5 — Update the [build] body to read from [_model]:
///             • _model.entries  instead of _entries
///             • _model.totalPrice  instead of _total
///             • _model.addOne(item)  instead of _addEntry(item)
///             • _model.removeEntry(index)  instead of _removeEntry(index)
///             • _model.clearAll()  instead of _clearCart()
///
///   Step 6 — Run flutter test test/ex03_test.dart to verify.
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // TODO Step 1: Add → final _model = CartModel();

  // Working setState-based state (remove in Step 2)
  final List<CartEntry> _entries = [];
  double _total = 0;

  // Working setState-based mutators (remove in Step 3)
  void _addEntry(MenuItem item) {
    setState(() {
      final index = _entries.indexWhere((e) => e.item == item);
      if (index >= 0) {
        _entries[index] = CartEntry(
          item: item,
          quantity: _entries[index].quantity + 1,
        );
      } else {
        _entries.add(CartEntry(item: item, quantity: 1));
      }
      _total += item.price;
    });
  }

  void _removeEntry(int index) {
    setState(() {
      _total -= _entries[index].item.price * _entries[index].quantity;
      _entries.removeAt(index);
    });
  }

  void _clearCart() {
    setState(() {
      _entries.clear();
      _total = 0;
    });
  }

  // Build (wrap with ListenableBuilder in Step 4)
  @override
  Widget build(BuildContext context) {
    // TODO Step 4: Wrap the Scaffold below in a ListenableBuilder.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Snack Shop'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Menu section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text('Menu', style: Theme.of(context).textTheme.titleMedium),
          ),
          ...kMenu.map(
            (item) => ListTile(
              leading: Icon(item.icon),
              title: Text(item.name),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('\$${item.price.toStringAsFixed(2)}'),
                  const SizedBox(width: 8),
                  TextButton(
                    // TODO Step 3: Replace _addEntry(item) with _model.addOne(item)
                    onPressed: () => _addEntry(item),
                    child: const Text('Add'),
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          // Cart section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Text(
              'Your Order',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Expanded(
            // TODO Step 5: Replace _entries with _model.entries
            child: _entries.isEmpty
                ? const Center(child: Text('Nothing ordered yet'))
                : ListView.builder(
                    itemCount: _entries.length,
                    itemBuilder: (context, index) {
                      final entry = _entries[index];
                      return ListTile(
                        title: Text(entry.item.name),
                        subtitle: Text(
                          '${entry.quantity} × '
                          '\$${entry.item.price.toStringAsFixed(2)}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '\$${(entry.item.price * entry.quantity).toStringAsFixed(2)}',
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              // TODO Step 3: Replace _removeEntry(index)
                              //             with _model.removeEntry(index)
                              onPressed: () => _removeEntry(index),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          // Total row
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Text(
                  // TODO Step 5: Replace _total with _model.totalPrice
                  'Total: \$${_total.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                ElevatedButton(
                  // TODO Step 3: Replace _clearCart() with _model.clearAll()
                  onPressed: _clearCart,
                  child: const Text('Clear Order'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
