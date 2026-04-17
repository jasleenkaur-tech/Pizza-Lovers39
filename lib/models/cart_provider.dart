// lib/models/cart_provider.dart

import 'package:flutter/foundation.dart';
import 'menu_item.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);
  int    get itemCount      => _items.fold(0, (s, i) => s + i.quantity);
  double get subtotal       => _items.fold(0, (s, i) => s + i.totalPrice);
  double get deliveryFee    => subtotal > 0 ? (subtotal >= 500 ? 0 : 40) : 0;
  double get total          => subtotal + deliveryFee;
  bool   get hasFreeDelivery => subtotal >= 500;

  void addItem(MenuItem menuItem, {String size = 'regular'}) {
    final idx = _items.indexWhere(
        (i) => i.menuItem.id == menuItem.id && i.selectedSize == size);
    if (idx >= 0) {
      _items[idx].quantity++;
    } else {
      _items.add(CartItem(menuItem: menuItem, selectedSize: size));
    }
    notifyListeners();
  }

  void removeItem(String itemId, {String size = 'regular'}) {
    final idx = _items.indexWhere(
        (i) => i.menuItem.id == itemId && i.selectedSize == size);
    if (idx >= 0) {
      if (_items[idx].quantity > 1) {
        _items[idx].quantity--;
      } else {
        _items.removeAt(idx);
      }
      notifyListeners();
    }
  }

  void deleteItem(String itemId, {String size = 'regular'}) {
    _items.removeWhere(
        (i) => i.menuItem.id == itemId && i.selectedSize == size);
    notifyListeners();
  }

  int getItemQuantity(String itemId, {String size = 'regular'}) {
    final list = _items.where(
        (i) => i.menuItem.id == itemId && i.selectedSize == size);
    return list.isEmpty ? 0 : list.first.quantity;
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
