// lib/models/order_model.dart

import 'menu_item.dart';

enum OrderStatus {
  pending,
  confirmed,
  preparing,
  outForDelivery,
  delivered,
  cancelled,
}

extension OrderStatusX on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.pending:        return 'Pending';
      case OrderStatus.confirmed:      return 'Confirmed';
      case OrderStatus.preparing:      return 'Preparing';
      case OrderStatus.outForDelivery: return 'Out for Delivery';
      case OrderStatus.delivered:      return 'Delivered';
      case OrderStatus.cancelled:      return 'Cancelled';
    }
  }

  String get emoji {
    switch (this) {
      case OrderStatus.pending:        return '🕐';
      case OrderStatus.confirmed:      return '✅';
      case OrderStatus.preparing:      return '👨‍🍳';
      case OrderStatus.outForDelivery: return '🛵';
      case OrderStatus.delivered:      return '🎉';
      case OrderStatus.cancelled:      return '❌';
    }
  }

  List<OrderStatus> get nextStatuses {
    switch (this) {
      case OrderStatus.pending:        return [OrderStatus.confirmed, OrderStatus.cancelled];
      case OrderStatus.confirmed:      return [OrderStatus.preparing, OrderStatus.cancelled];
      case OrderStatus.preparing:      return [OrderStatus.outForDelivery];
      case OrderStatus.outForDelivery: return [OrderStatus.delivered];
      default:                         return [];
    }
  }

  bool get isActive =>
      this != OrderStatus.delivered && this != OrderStatus.cancelled;
}

class OrderItem {
  final String itemName;
  final String itemEmoji;
  final int quantity;
  final double unitPrice;
  final String size;

  const OrderItem({
    required this.itemName,
    required this.itemEmoji,
    required this.quantity,
    required this.unitPrice,
    required this.size,
  });

  double get totalPrice => unitPrice * quantity;

  String get sizeLabel {
    switch (size) {
      case 'regular': return '7" Reg';
      case 'medium':  return '10" Med';
      case 'large':   return '13" Lrg';
      default:        return '';
    }
  }

  factory OrderItem.fromCartItem(CartItem c) => OrderItem(
        itemName:  c.menuItem.name,
        itemEmoji: c.menuItem.emoji,
        quantity:  c.quantity,
        unitPrice: c.menuItem.getPrice(c.selectedSize),
        size:      c.selectedSize,
      );
}

class Order {
  final String id;
  final List<OrderItem> items;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final String paymentMethod;
  final DateTime placedAt;
  OrderStatus status;
  final String? customerName;
  final String? customerPhone;
  final String? address;
  DateTime? updatedAt;

  Order({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.paymentMethod,
    required this.placedAt,
    this.status = OrderStatus.pending,
    this.customerName,
    this.customerPhone,
    this.address,
    this.updatedAt,
  });

  int    get totalItemCount => items.fold(0, (s, i) => s + i.quantity);
  String get shortId        => id.substring(id.length - 6).toUpperCase();

  factory Order.fromCart({
    required List<CartItem> cartItems,
    required double subtotal,
    required double deliveryFee,
    required double total,
    required String paymentMethod,
    String? customerName,
    String? customerPhone,
    String? address,
  }) {
    final now = DateTime.now();
    return Order(
      id:            'PL${now.millisecondsSinceEpoch}',
      items:         cartItems.map(OrderItem.fromCartItem).toList(),
      subtotal:      subtotal,
      deliveryFee:   deliveryFee,
      total:         total,
      paymentMethod: paymentMethod,
      placedAt:      now,
      customerName:  customerName,
      customerPhone: customerPhone,
      address:       address,
    );
  }
}
