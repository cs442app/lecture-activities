import 'package:flutter/material.dart';

import 'menu.dart';

// Run this exercise by updating main.dart to:
//   import 'ex02_cart.dart';

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

/// A cart screen where customers build their order from the snack shop menu.
///
/// This widget contains three bugs related to state management. Find and fix
/// them so that all four tests in test/ex02_test.dart pass.
///
/// Symptoms to look for:
///   1. Tapping "Add" has no visible effect.
///   2. Removing an item leaves the total incorrect.
///   3. Clearing the cart leaves the total incorrect.
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<CartEntry> _entries = [];
  double _total = 0;

  // Mutating methods

  void _addEntry(MenuItem item) {
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
  }

  void _removeEntry(int index) {
    setState(() {
      _entries.removeAt(index);
    });
  }

  void _clearCart() {
    setState(() {
      _entries.clear();
    });
  }

  // Build

  @override
  Widget build(BuildContext context) {
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
                  'Total: \$${_total.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                ElevatedButton(
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
