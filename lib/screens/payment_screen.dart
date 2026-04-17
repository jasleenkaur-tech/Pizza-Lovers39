import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_provider.dart';
import '../models/menu_item.dart';
import '../models/order_provider.dart';
import '../models/order_model.dart';
import '../models/ui_provider.dart';
import '../utils/app_theme.dart';

class PaymentScreen extends StatefulWidget {
  final double total;
  final List<CartItem> cartItems;
  const PaymentScreen({super.key, required this.total, required this.cartItems});
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _method = 0;
  final _upiCtrl   = TextEditingController();
  final _cardCtrl  = TextEditingController();
  final _expCtrl   = TextEditingController();
  final _cvvCtrl   = TextEditingController();
  final _nameCtrl  = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addrCtrl  = TextEditingController();
  bool _loading = false;
  String? _upiErr;

  static const _methods = [
    (Icons.qr_code,     'UPI / QR Pay',       'PhonePe, GPay, Paytm'),
    (Icons.credit_card, 'Credit / Debit Card', 'Visa, Mastercard, RuPay'),
    (Icons.money,       'Cash on Delivery',    'Pay when delivered'),
  ];

  @override
  void dispose() {
    _upiCtrl.dispose();
    _cardCtrl.dispose();
    _expCtrl.dispose();
    _cvvCtrl.dispose();
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addrCtrl.dispose();
    super.dispose();
  }

  Future<void> _pay() async {
    if (_method == 0 && _upiCtrl.text.trim().isEmpty) {
      setState(() => _upiErr = 'Enter UPI ID');
      return;
    }
    if (_method == 1 && (_cardCtrl.text.trim().length < 16 || _nameCtrl.text.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fill all card details')));
      return;
    }

    setState(() { _loading = true; _upiErr = null; });
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _loading = false);

    final cart = context.read<CartProvider>();
    final order = context.read<OrderProvider>().placeOrder(
      cartItems:     widget.cartItems,
      subtotal:      cart.subtotal,
      deliveryFee:   cart.deliveryFee,
      total:         widget.total,
      paymentMethod: _methods[_method].$2,
      customerName:  _nameCtrl.text.trim().isEmpty ? 'Customer' : _nameCtrl.text.trim(),
      customerPhone: _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
      address:       _addrCtrl.text.trim().isEmpty  ? null : _addrCtrl.text.trim(),
    );
    cart.clearCart();

    if (!mounted) return;
    Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentSuccessScreen(order: order)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AmountCard(total: widget.total, count: widget.cartItems.length),
            const SizedBox(height: 20),
            const Text('Delivery Details', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppTheme.textDark)),
            const SizedBox(height: 12),
            _tf(_nameCtrl,  'Your Name', Icons.person_outline, TextInputType.name),
            const SizedBox(height: 10),
            _tf(_phoneCtrl, 'Phone Number', Icons.phone_outlined, TextInputType.phone),
            const SizedBox(height: 10),
            _tf(_addrCtrl,  'Delivery Address', Icons.location_on_outlined, TextInputType.streetAddress, lines: 2),
            const SizedBox(height: 20),
            const Text('Select Payment Method', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppTheme.textDark)),
            const SizedBox(height: 12),
            ...List.generate(_methods.length, (i) => _MethodTile(
              icon: _methods[i].$1, title: _methods[i].$2, sub: _methods[i].$3, selected: _method == i,
              onTap: () => setState(() => _method = i),
            )),
            const SizedBox(height: 16),
            AnimatedSwitcher(duration: const Duration(milliseconds: 300), child: _method == 0 ? _upiForm() : _method == 1 ? _cardForm() : _codInfo()),
            const SizedBox(height: 24),
            SizedBox(width: double.infinity, child: ElevatedButton(
                onPressed: _loading ? null : _pay,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: _loading
                    ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                    : Text('Pay ₹${widget.total.toStringAsFixed(0)}', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)))),
            const SizedBox(height: 12),
            const Center(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.lock_outline, size: 14, color: AppTheme.textGrey), SizedBox(width: 4), Text('Secured & Encrypted Payment', style: TextStyle(color: AppTheme.textGrey, fontSize: 12))])),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _tf(TextEditingController c, String label, IconData icon, TextInputType type, {int lines = 1}) {
    return TextFormField(controller: c, keyboardType: type, maxLines: lines, decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))));
  }

  Widget _upiForm() {
    return Column(key: const ValueKey('upi'), crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('UPI Details', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
      const SizedBox(height: 10),
      Row(children: [('📱', 'GPay'),('💙', 'PhonePe'),('🛍️', 'Paytm'),('💰', 'Amazon')].map((a) => Expanded(child: GestureDetector(onTap: () => setState(() { _upiCtrl.text = 'your@${a.$2.toLowerCase()}'; _upiErr = null; }), child: Container(margin: const EdgeInsets.only(right: 8), padding: const EdgeInsets.symmetric(vertical: 10), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade200)), child: Column(children: [Text(a.$1, style: const TextStyle(fontSize: 20)), const SizedBox(height: 3), Text(a.$2, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.textGrey))]))))).toList()),
      const SizedBox(height: 12),
      TextFormField(controller: _upiCtrl, keyboardType: TextInputType.emailAddress, decoration: InputDecoration(labelText: 'Enter UPI ID', hintText: '9878394950@okbizaxis', errorText: _upiErr, prefixIcon: const Icon(Icons.qr_code), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))), onChanged: (_) => setState(() => _upiErr = null)),
    ]);
  }

  Widget _cardForm() {
    return Column(key: const ValueKey('card'), crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Card Details', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
      const SizedBox(height: 10),
      _tf(_cardCtrl, 'Card Number', Icons.credit_card, TextInputType.number),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: TextFormField(controller: _expCtrl, keyboardType: TextInputType.number, maxLength: 5, decoration: InputDecoration(labelText: 'MM/YY', counterText: '', prefixIcon: const Icon(Icons.date_range), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))))),
        const SizedBox(width: 12),
        Expanded(child: TextFormField(controller: _cvvCtrl, keyboardType: TextInputType.number, maxLength: 3, obscureText: true, decoration: InputDecoration(labelText: 'CVV', counterText: '', prefixIcon: const Icon(Icons.lock_outline), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))))),
      ]),
    ]);
  }

  Widget _codInfo() {
    return Container(key: const ValueKey('cod'), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.green.withOpacity(0.08), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.green.withOpacity(0.3))), child: const Row(children: [Text('💰', style: TextStyle(fontSize: 32)), SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Cash on Delivery', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.green)), SizedBox(height: 4), Text('Keep exact change ready. Our delivery executive will collect the amount.', style: TextStyle(color: AppTheme.textGrey, fontSize: 12))]))]));
  }
}

class _AmountCard extends StatelessWidget {
  final double total;
  final int count;
  const _AmountCard({required this.total, required this.count});
  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppTheme.primary, Color(0xFFCC4400)], begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 6))]), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Order Total', style: TextStyle(color: Colors.white70, fontSize: 13)), const SizedBox(height: 4), Text('₹${total.toStringAsFixed(0)}', style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900)), const SizedBox(height: 8), Text('$count item${count > 1 ? 's' : ''} in your order', style: const TextStyle(color: Colors.white70, fontSize: 12))]));
  }
}

class _MethodTile extends StatelessWidget {
  final IconData icon; final String title, sub; final bool selected; final VoidCallback onTap;
  const _MethodTile({required this.icon, required this.title, required this.sub, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: AnimatedContainer(duration: const Duration(milliseconds: 200), margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), decoration: BoxDecoration(color: selected ? AppTheme.primary.withOpacity(0.06) : Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: selected ? AppTheme.primary : Colors.grey.shade200, width: selected ? 2 : 1)), child: Row(children: [Container(width: 44, height: 44, decoration: BoxDecoration(color: selected ? AppTheme.primary : Colors.grey.shade100, borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: selected ? Colors.white : AppTheme.textGrey, size: 22)), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: selected ? AppTheme.primary : AppTheme.textDark)), Text(sub, style: const TextStyle(color: AppTheme.textGrey, fontSize: 12))])), Icon(selected ? Icons.check_circle : Icons.radio_button_unchecked, color: selected ? AppTheme.primary : AppTheme.textGrey, size: 22)])));
  }
}

class PaymentSuccessScreen extends StatelessWidget {
  final Order order;
  const PaymentSuccessScreen({super.key, required this.order});

  void _goHome(BuildContext context) { Navigator.of(context).popUntil((route) => route.isFirst); }
  
  void _viewOrders(BuildContext context) {
    context.read<UiProvider>().setTab(4); // Switch to Profile tab
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, leading: IconButton(icon: const Icon(Icons.home_outlined, color: AppTheme.textDark), onPressed: () => _goHome(context), tooltip: 'Back to Home'), title: const Text('Order Confirmed', style: TextStyle(color: AppTheme.textDark, fontWeight: FontWeight.w700))),
      body: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const SizedBox(height: 10),
        TweenAnimationBuilder<double>(tween: Tween(begin: 0, end: 1), duration: const Duration(milliseconds: 700), curve: Curves.elasticOut, builder: (_, v, child) => Transform.scale(scale: v, child: Opacity(opacity: v.clamp(0, 1), child: child)), child: Container(width: 120, height: 120, decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)], begin: Alignment.topLeft, end: Alignment.bottomRight), shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.4), blurRadius: 28, offset: const Offset(0, 10))]), child: const Icon(Icons.check_rounded, color: Colors.white, size: 66))),
        const SizedBox(height: 24),
        const Text('Order Placed! 🎉', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppTheme.textDark)),
        const SizedBox(height: 6),
        const Text('Your delicious food is being prepared', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textGrey, fontSize: 14)),
        const SizedBox(height: 28),
        Container(width: double.infinity, padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 16, offset: const Offset(0, 4))]), child: Column(children: [_row('Order ID',  '#${order.shortId}'), const Divider(height: 20), _row('Amount Paid', '₹${order.total.toStringAsFixed(0)}', bold: true, color: Colors.green), const SizedBox(height: 8), _row('Payment Via', order.paymentMethod), const Divider(height: 20), _row('Estimated Time', '30–40 minutes'), const SizedBox(height: 8), _row('Call Us', '9878394950')])),
        const SizedBox(height: 18),
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.orange.withOpacity(0.35))), child: const Row(children: [Text('🛵', style: TextStyle(fontSize: 30)), SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Out for Delivery Soon!', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.orange, fontSize: 14)), SizedBox(height: 2), Text('Sit back and relax — we\'ve got your food!', style: TextStyle(color: AppTheme.textGrey, fontSize: 12))]))])),
        const SizedBox(height: 28),
        SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: () => _goHome(context), icon: const Icon(Icons.home_rounded), label: const Text('Back to Home', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)), style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))))),
        const SizedBox(height: 12),
        SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: () => _viewOrders(context), icon: const Icon(Icons.receipt_long_outlined, color: AppTheme.primary), label: const Text('View My Orders', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.primary)), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), side: const BorderSide(color: AppTheme.primary), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))))),
      ]))),
    );
  }

  Widget _row(String label, String value, {bool bold = false, Color? color}) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: const TextStyle(color: AppTheme.textGrey, fontSize: 13)), Text(value, style: TextStyle(fontWeight: bold ? FontWeight.w800 : FontWeight.w600, fontSize: bold ? 16 : 13, color: color ?? AppTheme.textDark))]);
  }
}
