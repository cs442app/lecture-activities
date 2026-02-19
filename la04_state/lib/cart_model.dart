import 'package:flutter/foundation.dart';

import 'menu.dart';

/// Holds the state of the shopping cart and notifies listeners on every change.
///
/// TODO (Exercise 3): Implement all members of this class.
///
/// Each mutating method must call [notifyListeners] after modifying [_entries]
/// so that any [ListenableBuilder] watching this model will rebuild.
class CartModel extends ChangeNotifier {
  // TODO: Declare a private List<CartEntry> field to store cart entries.

  /// An unmodifiable view of the current cart entries.
  List<CartEntry> get entries => throw UnimplementedError();

  /// The sum of (price × quantity) for all entries.
  ///
  /// Compute this on the fly from [_entries] rather than storing it separately.
  double get totalPrice => throw UnimplementedError();

  /// The total number of individual items across all entries
  /// (i.e., the sum of every entry's quantity).
  int get totalItems => throw UnimplementedError();

  /// Returns the quantity of [item] currently in the cart, or 0 if absent.
  int quantityOf(MenuItem item) => throw UnimplementedError();

  /// Adds one unit of [item] to the cart.
  ///
  /// If [item] is already present, increments its quantity.
  /// Calls [notifyListeners] after the change.
  void addOne(MenuItem item) => throw UnimplementedError();

  /// Removes one unit of [item] from the cart.
  ///
  /// If the quantity would drop to zero, removes the entry entirely.
  /// Does nothing if [item] is not in the cart.
  /// Calls [notifyListeners] after the change.
  void removeOne(MenuItem item) => throw UnimplementedError();

  /// Removes the entire cart entry at [index].
  ///
  /// Calls [notifyListeners] after the change.
  void removeEntry(int index) => throw UnimplementedError();

  /// Clears all entries from the cart.
  ///
  /// Calls [notifyListeners] after the change.
  void clearAll() => throw UnimplementedError();
}
