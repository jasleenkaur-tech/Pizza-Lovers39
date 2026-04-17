// lib/models/order_provider.dart

import 'package:flutter/foundation.dart';
import 'order_model.dart';
import 'menu_item.dart';

class OrderProvider extends ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders         => List.unmodifiable(_orders.reversed.toList());
  int    get totalOrders         => _orders.length;
  int    get pendingCount        => _orders.where((o) => o.status == OrderStatus.pending).length;
  int    get deliveredCount      => _orders.where((o) => o.status == OrderStatus.delivered).length;

  double get todayRevenue {
    final t = DateTime.now();
    return _orders
        .where((o) =>
            o.status == OrderStatus.delivered &&
            o.placedAt.year  == t.year &&
            o.placedAt.month == t.month &&
            o.placedAt.day   == t.day)
        .fold(0.0, (s, o) => s + o.total);
  }

  double get totalRevenue =>
      _orders.where((o) => o.status == OrderStatus.delivered)
             .fold(0.0, (s, o) => s + o.total);

  List<Order> get pendingOrders =>
      _orders.where((o) => o.status == OrderStatus.pending).toList().reversed.toList();

  List<Order> byStatus(OrderStatus s) =>
      _orders.where((o) => o.status == s).toList().reversed.toList();

  Order placeOrder({
    required List<CartItem> cartItems,
    required double subtotal,
    required double deliveryFee,
    required double total,
    required String paymentMethod,
    String? customerName,
    String? customerPhone,
    String? address,
  }) {
    final order = Order.fromCart(
      cartItems:     cartItems,
      subtotal:      subtotal,
      deliveryFee:   deliveryFee,
      total:         total,
      paymentMethod: paymentMethod,
      customerName:  customerName,
      customerPhone: customerPhone,
      address:       address,
    );
    _orders.add(order);
    notifyListeners();
    return order;
  }

  void updateStatus(String orderId, OrderStatus newStatus) {
    final idx = _orders.indexWhere((o) => o.id == orderId);
    if (idx >= 0) {
      _orders[idx].status    = newStatus;
      _orders[idx].updatedAt = DateTime.now();
      notifyListeners();
    }
  }

  void cancelOrder(String orderId) => updateStatus(orderId, OrderStatus.cancelled);

  Order? getById(String orderId) {
    try { return _orders.firstWhere((o) => o.id == orderId); }
    catch (_) { return null; }
  }
}
