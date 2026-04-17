// lib/models/menu_item.dart

enum MenuCategory {
  vegPizza,
  burger,
  pasta,
  shakes,
  wraps,
  fries,
  sandwich,
  tacos,
  snacks,
  garlic,
  meals,
  special,
}

class MenuItem {
  final String id;
  final String name;
  final String description;
  final Map<String, double>? prices;
  final double? price;
  final MenuCategory category;
  final String? subCategory;
  final bool isVeg;
  final bool isBestseller;
  final String emoji;

  MenuItem({
    required this.id,
    required this.name,
    this.description = '',
    this.prices,
    this.price,
    required this.category,
    this.subCategory,
    this.isVeg = true,
    this.isBestseller = false,
    this.emoji = '🍕',
  });

  double getPrice([String size = 'regular']) {
    if (prices != null) return prices![size] ?? 0;
    return price ?? 0;
  }
}

class CartItem {
  final MenuItem menuItem;
  int quantity;
  String selectedSize;

  CartItem({
    required this.menuItem,
    this.quantity = 1,
    this.selectedSize = 'regular',
  });

  double get totalPrice => menuItem.getPrice(selectedSize) * quantity;
}
