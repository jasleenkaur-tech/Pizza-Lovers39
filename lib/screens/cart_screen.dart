// lib/screens/cart_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_provider.dart';
import '../models/menu_item.dart';
import '../utils/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'payment_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          Consumer<CartProvider>(builder: (_, cart, __) => cart.itemCount > 0
              ? TextButton(onPressed: () => _clear(context, cart),
                  child: const Text('Clear All', style: TextStyle(color: Colors.white70)))
              : const SizedBox.shrink()),
        ],
      ),
      body: Consumer<CartProvider>(builder: (context, cart, _) {
        if (cart.items.isEmpty) return _empty(context);
        return Column(children: [
          Expanded(child: ListView(padding: const EdgeInsets.all(12), children: [
            ...cart.items.map((ci) => _CartTile(cartItem: ci)),
            const SizedBox(height: 8),
            _Summary(cart: cart),
            const SizedBox(height: 80),
          ])),
          _Checkout(cart: cart),
        ]);
      }),
    );
  }

  Widget _empty(BuildContext context) => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    const Text('🛒', style: TextStyle(fontSize: 64)),
    const SizedBox(height: 16),
    const Text('Your cart is empty', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.textDark)),
    const SizedBox(height: 8),
    const Text('Add items to get started', style: TextStyle(color: AppTheme.textGrey)),
    const SizedBox(height: 24),
    ElevatedButton.icon(onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back), label: const Text('Browse Menu')),
  ]));

  void _clear(BuildContext context, CartProvider cart) {
    showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text('Clear Cart?'),
      content: const Text('Remove all items?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(onPressed: () { cart.clearCart(); Navigator.pop(context); }, child: const Text('Clear')),
      ],
    ));
  }
}

class _CartTile extends StatelessWidget {
  final CartItem cartItem;
  const _CartTile({required this.cartItem});
  String _sl(String s) { switch(s){ case 'regular': return '7" Regular'; case 'medium': return '10" Medium'; case 'large': return '13" Large'; default: return s; } }
  @override
  Widget build(BuildContext context) {
    final item = cartItem.menuItem;
    return Card(margin: const EdgeInsets.only(bottom: 8), child: Padding(padding: const EdgeInsets.all(12), child: Row(children: [
      Container(width: 52, height: 52,
        decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(10)),
        child: Center(child: Text(item.emoji, style: const TextStyle(fontSize: 26)))),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [VegIndicator(isVeg: item.isVeg), const SizedBox(width: 6),
          Expanded(child: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis))]),
        if (item.prices != null) Padding(padding: const EdgeInsets.only(top: 2),
          child: Text(_sl(cartItem.selectedSize), style: const TextStyle(color: AppTheme.textGrey, fontSize: 12))),
        Text('₹${item.getPrice(cartItem.selectedSize).toStringAsFixed(0)} × ${cartItem.quantity}',
            style: const TextStyle(color: AppTheme.textGrey, fontSize: 12)),
      ])),
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text('₹${cartItem.totalPrice.toStringAsFixed(0)}',
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppTheme.primary)),
        const SizedBox(height: 6),
        QuantityControl(item: item, size: cartItem.selectedSize, compact: true),
      ]),
    ])));
  }
}

class _Summary extends StatelessWidget {
  final CartProvider cart;
  const _Summary({required this.cart});
  Widget _row(String l, String v, {bool bold = false, Color? vc}) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(l, style: TextStyle(fontSize: 14, fontWeight: bold ? FontWeight.w700 : FontWeight.normal,
          color: bold ? AppTheme.textDark : AppTheme.textGrey)),
      Text(v, style: TextStyle(fontSize: bold ? 16 : 14, fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
          color: vc ?? AppTheme.textDark)),
    ],
  );
  @override
  Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const Text('Order Summary', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
    const SizedBox(height: 12), const Divider(),
    _row('Subtotal', '₹${cart.subtotal.toStringAsFixed(0)}'),
    const SizedBox(height: 6),
    _row('Delivery', cart.hasFreeDelivery ? 'FREE 🎉' : '₹${cart.deliveryFee.toStringAsFixed(0)}',
        vc: cart.hasFreeDelivery ? Colors.green : null),
    if (!cart.hasFreeDelivery) ...[const SizedBox(height: 4),
      Text('Add ₹${(500 - cart.subtotal).toStringAsFixed(0)} more for free delivery',
          style: const TextStyle(color: AppTheme.textGrey, fontSize: 11))],
    const Divider(height: 20),
    _row('Total', '₹${cart.total.toStringAsFixed(0)}', bold: true, vc: AppTheme.primary),
  ])));
}

class _Checkout extends StatelessWidget {
  final CartProvider cart;
  const _Checkout({required this.cart});
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
    decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -2))]),
    child: SizedBox(width: double.infinity, child: ElevatedButton(
      onPressed: () => Navigator.push(context, MaterialPageRoute(
          builder: (_) => PaymentScreen(total: cart.total, cartItems: cart.items.toList()))),
      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
      child: Text('Proceed to Pay · ₹${cart.total.toStringAsFixed(0)}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
    )),
  );
}
