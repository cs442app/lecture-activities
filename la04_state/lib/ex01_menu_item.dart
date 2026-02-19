import 'package:flutter/material.dart';

import 'menu.dart';

// Run this exercise by ensuring main.dart contains:
//   import 'ex01_menu_item.dart';
//   void main() => runApp(const SnackShopApp());

class SnackShopApp extends StatelessWidget {
  const SnackShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snack Shop',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      home: const MenuScreen(),
    );
  }
}

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Snack Shop'),
      ),
      body: ListView(
        children: kMenu.map((item) => OrderItem(item: item)).toList(),
      ),
    );
  }
}

/// Displays a single menu item with a quantity picker and a running subtotal.
///
/// TODO: Implement this StatefulWidget.
///
/// State to manage:
///   [_quantity] — the number of this item in the order. Starts at 0 and
///   must never go below 0.
///
/// Build a [ListTile] with:
///   leading  : Icon(widget.item.icon)
///   title    : widget.item.name
///   subtitle : widget.item.description and price
///              (e.g., Text('\$${widget.item.price.toStringAsFixed(2)}'))
///   trailing : a [Row] (mainAxisSize: MainAxisSize.min) containing:
///                [IconButton] with Icons.remove — calls _decrement
///                [Text]       showing _quantity
///                [IconButton] with Icons.add    — calls _increment
///                [SizedBox]   width: 8
///                [Text]       showing the subtotal
///                             ('\$${(widget.item.price * _quantity).toStringAsFixed(2)}')
class OrderItem extends StatefulWidget {
  final MenuItem item;

  const OrderItem({super.key, required this.item});

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  // TODO: Declare _quantity (int, starts at 0).

  // TODO: Implement _increment.
  //       Increase _quantity by 1 using setState.

  // TODO: Implement _decrement.
  //       Decrease _quantity by 1 using setState, but not below 0.

  @override
  Widget build(BuildContext context) {
    // TODO: Replace Placeholder with the ListTile described above.
    //       Access the menu item via widget.item.
    return const Placeholder();
  }
}
