import 'package:flutter/material.dart';

/// A single item on the snack shop menu.
class MenuItem {
  final String name;
  final String description;
  final double price;
  final IconData icon;

  const MenuItem({
    required this.name,
    required this.description,
    required this.price,
    required this.icon,
  });
}

/// One line in the cart: a menu item and how many were ordered.
class CartEntry {
  final MenuItem item;
  final int quantity;

  const CartEntry({required this.item, required this.quantity});
}

/// The snack shop menu.
const List<MenuItem> kMenu = [
  MenuItem(
    name: 'Pretzel',
    description: 'Warm, soft, and salty',
    price: 3.50,
    icon: Icons.bakery_dining,
  ),
  MenuItem(
    name: 'Nachos',
    description: 'Chips with melted cheese and jalapeños',
    price: 5.00,
    icon: Icons.lunch_dining,
  ),
  MenuItem(
    name: 'Popcorn',
    description: 'Classic buttery popcorn',
    price: 2.50,
    icon: Icons.local_movies,
  ),
  MenuItem(
    name: 'Hot Dog',
    description: 'Ballpark-style with all the toppings',
    price: 4.50,
    icon: Icons.fastfood,
  ),
  MenuItem(
    name: 'Lemonade',
    description: 'Fresh-squeezed with a twist',
    price: 3.00,
    icon: Icons.local_drink,
  ),
  MenuItem(
    name: 'Cookie',
    description: 'Chocolate chip, still warm',
    price: 2.00,
    icon: Icons.cookie,
  ),
];
