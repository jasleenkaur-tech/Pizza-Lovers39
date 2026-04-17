// lib/screens/admin_screen.dart
//
// Admin Panel access rules:
//   - Phone 9878394950 → owner's phone (hardcoded in kAdminPhones)
//   - Phone 9878497680 → second admin phone
//   - Anyone else who tries to open this screen sees a "Not Authorized" page
//   - If logged in as admin → goes directly to AdminDashboard (no PIN needed)
//   - If NOT logged in / not admin → shows blocked screen

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/order_model.dart';
import '../models/order_provider.dart';
import '../models/auth_provider.dart';
import '../utils/app_theme.dart';

// ── Admin Gate: checks if the logged-in user is an admin ───────
// Use this widget as the entry point from the drawer / profile tab
class AdminGate extends StatelessWidget {
  const AdminGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (!auth.isLoggedIn) {
      return const _NotAuthorized(reason: 'You must be logged in to access the Admin Panel.');
    }
    if (!auth.isAdmin) {
      return const _NotAuthorized(reason: 'Your account does not have admin access.\n\nOnly the restaurant owner can manage orders.');
    }

    // Admin confirmed → go straight to dashboard
    return const AdminDashboard();
  }
}

// ── Not Authorized screen ──────────────────────────────────────
class _NotAuthorized extends StatelessWidget {
  final String reason;
  const _NotAuthorized({required this.reason});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(width: 90, height: 90,
                  decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), shape: BoxShape.circle),
                  child: const Icon(Icons.block, color: Colors.red, size: 48)),
              const SizedBox(height: 24),
              const Text('Access Denied', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppTheme.textDark)),
              const SizedBox(height: 12),
              Text(reason, textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.textGrey, fontSize: 14, height: 1.6)),
              const SizedBox(height: 32),
              SizedBox(width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Go Back', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  )),
            ]),
          ),
        ),
      ),
    );
  }
}

// ── Keep AdminLoginScreen as a PIN-based fallback (used from drawer) ─
// This is only reachable from the side drawer — admin phones skip it
class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});
  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _ctrl = TextEditingController();
  bool _hide  = true;
  String? _err;
  // PIN is a secondary fallback — primary auth is phone-based (kAdminPhones)
  static const _pin = '3939';

  @override
  void initState() {
    super.initState();
    // If user is already logged in as admin → skip PIN screen entirely
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      if (auth.isLoggedIn && auth.isAdmin) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdminDashboard()));
      }
    });
  }

  void _login() {
    if (_ctrl.text.trim() == _pin) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdminDashboard()));
    } else {
      setState(() => _err = 'Incorrect PIN. Try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(child: Center(child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(width: 90, height: 90,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppTheme.primary, Color(0xFFCC4400)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.35), blurRadius: 20, offset: const Offset(0, 8))]),
              child: const Center(child: Text('👨‍🍳', style: TextStyle(fontSize: 42)))),
          const SizedBox(height: 28),
          const Text('Admin Panel', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppTheme.textDark)),
          const Text('Pizza Lovers 39 — Authorized Access Only', style: TextStyle(fontSize: 13, color: AppTheme.textGrey)),
          const SizedBox(height: 8),
          Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.orange.withOpacity(0.3))),
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.info_outline, color: Colors.orange, size: 16), SizedBox(width: 6),
                Text('Only restaurant owner can access', style: TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.w600)),
              ])),
          const SizedBox(height: 36),
          TextField(controller: _ctrl, obscureText: _hide, keyboardType: TextInputType.number, maxLength: 6,
              onSubmitted: (_) => _login(),
              decoration: InputDecoration(
                  labelText: 'Admin PIN', hintText: 'Enter your PIN', counterText: '',
                  prefixIcon: const Icon(Icons.lock_outline), errorText: _err,
                  suffixIcon: IconButton(icon: Icon(_hide ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _hide = !_hide)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  filled: true, fillColor: Colors.white)),
          const SizedBox(height: 20),
          SizedBox(width: double.infinity, child: ElevatedButton.icon(
              onPressed: _login,
              icon: const Icon(Icons.login),
              label: const Text('Login to Admin', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)))),
          const SizedBox(height: 16),
          Text('Admin PIN is private — contact owner', style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
        ]),
      ))),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  ADMIN DASHBOARD
// ═══════════════════════════════════════════════════════════════
class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});
  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> with SingleTickerProviderStateMixin {
  late TabController _tab;
  @override
  void initState() { super.initState(); _tab = TabController(length: 3, vsync: this); }
  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: Row(children: [
          const Text('👨‍🍳', style: TextStyle(fontSize: 22)), const SizedBox(width: 8),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Admin Dashboard', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            if (auth.isLoggedIn)
              Text(auth.displayName, style: const TextStyle(fontSize: 11, color: Colors.white70)),
          ]),
        ]),
        actions: [IconButton(icon: const Icon(Icons.logout), tooltip: 'Exit Admin', onPressed: () => Navigator.of(context).pop())],
        bottom: TabBar(controller: _tab, labelColor: Colors.white, unselectedLabelColor: Colors.white60,
            indicatorColor: AppTheme.accent, indicatorWeight: 3,
            tabs: const [
              Tab(icon: Icon(Icons.dashboard_outlined),  text: 'Overview'),
              Tab(icon: Icon(Icons.list_alt_outlined),   text: 'All Orders'),
              Tab(icon: Icon(Icons.filter_list_outlined),text: 'By Status'),
            ]),
      ),
      body: TabBarView(controller: _tab, children: [_Overview(), _AllOrders(), _ByStatus()]),
    );
  }
}

// ── Overview tab ───────────────────────────────────────────────
class _Overview extends StatelessWidget {
  Color _sc(OrderStatus s) { switch(s){ case OrderStatus.pending: return Colors.orange; case OrderStatus.confirmed: return Colors.blue; case OrderStatus.preparing: return Colors.purple; case OrderStatus.outForDelivery: return Colors.indigo; case OrderStatus.delivered: return Colors.green; case OrderStatus.cancelled: return Colors.red; } }
  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(builder: (ctx, op, _) => ListView(padding: const EdgeInsets.all(16), children: [
      const Text('Today\'s Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.textDark)),
      const SizedBox(height: 12),
      GridView.count(crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 14, mainAxisSpacing: 14, childAspectRatio: 1.2,
          children: [
            _Stat('Total Orders',   '${op.totalOrders}',                      Icons.receipt_long_outlined,    const Color(0xFF1565C0)),
            _Stat('Pending',        '${op.pendingCount}',                     Icons.access_time_outlined,     Colors.orange),
            _Stat('Revenue Today',  '₹${op.todayRevenue.toStringAsFixed(0)}', Icons.currency_rupee_outlined,  Colors.green),
            _Stat('Delivered',      '${op.deliveredCount}',                   Icons.check_circle_outline,     Colors.teal),
          ]),
      const SizedBox(height: 24),
      Row(children: [
        const Text('⚡ Needs Attention', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.textDark)),
        const Spacer(),
        if (op.pendingCount > 0) Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(20)),
            child: Text('${op.pendingCount} pending', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))),
      ]),
      const SizedBox(height: 10),
      if (op.pendingOrders.isEmpty)
        const _Empty(emoji: '✅', msg: 'No pending orders right now!')
      else
        ...op.pendingOrders.map((o) => _OrderCard(order: o)),
      const SizedBox(height: 24),
      const Text('Order Pipeline', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.textDark)),
      const SizedBox(height: 10),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
        child: Column(children: [
          (OrderStatus.pending,        Colors.orange, '🕐'),
          (OrderStatus.confirmed,      Colors.blue,   '✅'),
          (OrderStatus.preparing,      Colors.purple, '👨‍🍳'),
          (OrderStatus.outForDelivery, Colors.indigo, '🛵'),
          (OrderStatus.delivered,      Colors.green,  '🎉'),
        ].map((s) {
          final count = op.byStatus(s.$1).length;
          return Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Row(children: [
            Text(s.$3, style: const TextStyle(fontSize: 20)), const SizedBox(width: 12),
            Expanded(child: Text(s.$1.label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppTheme.textDark))),
            Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: count > 0 ? s.$2.withOpacity(0.12) : Colors.grey.shade100, borderRadius: BorderRadius.circular(20)),
                child: Text('$count', style: TextStyle(fontWeight: FontWeight.w800, color: count > 0 ? s.$2 : AppTheme.textGrey))),
          ]));
        }).toList()),
      ),
    ]));
  }
}

class _AllOrders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(builder: (ctx, op, _) => op.orders.isEmpty
        ? const _Empty(emoji: '🍕', msg: 'No orders yet.\nPlace an order from the customer side!')
        : ListView.builder(padding: const EdgeInsets.all(12), itemCount: op.orders.length,
        itemBuilder: (ctx, i) => _OrderCard(order: op.orders[i])));
  }
}

class _ByStatus extends StatefulWidget {
  @override
  State<_ByStatus> createState() => _ByStatusState();
}
class _ByStatusState extends State<_ByStatus> {
  OrderStatus _sel = OrderStatus.pending;
  Color _sc(OrderStatus s) { switch(s){ case OrderStatus.pending: return Colors.orange; case OrderStatus.confirmed: return Colors.blue; case OrderStatus.preparing: return Colors.purple; case OrderStatus.outForDelivery: return Colors.indigo; case OrderStatus.delivered: return Colors.green; case OrderStatus.cancelled: return Colors.red; } }
  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(builder: (ctx, op, _) {
      final filtered = op.byStatus(_sel);
      return Column(children: [
        Container(color: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(
                children: OrderStatus.values.map((s) {
                  final cnt = op.byStatus(s).length;
                  final sel = _sel == s;
                  return GestureDetector(
                      onTap: () => setState(() => _sel = s),
                      child: AnimatedContainer(duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                              color: sel ? _sc(s) : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: sel ? _sc(s) : Colors.grey.shade300)),
                          child: Row(children: [
                            Text(s.emoji, style: const TextStyle(fontSize: 14)), const SizedBox(width: 6),
                            Text(s.label, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: sel ? Colors.white : AppTheme.textGrey)),
                            const SizedBox(width: 6),
                            Container(width: 20, height: 20, decoration: BoxDecoration(color: sel ? Colors.white.withOpacity(0.3) : _sc(s).withOpacity(0.15), shape: BoxShape.circle),
                                child: Center(child: Text('$cnt', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: sel ? Colors.white : _sc(s))))),
                          ])));
                }).toList()))),
        Expanded(child: filtered.isEmpty
            ? _Empty(emoji: _sel.emoji, msg: 'No ${_sel.label} orders')
            : ListView.builder(padding: const EdgeInsets.all(12), itemCount: filtered.length,
            itemBuilder: (ctx, i) => _OrderCard(order: filtered[i]))),
      ]);
    });
  }
}

class _OrderCard extends StatefulWidget {
  final Order order;
  const _OrderCard({required this.order});
  @override
  State<_OrderCard> createState() => _OrderCardState();
}
class _OrderCardState extends State<_OrderCard> {
  bool _exp = false;
  Color get _c { switch(widget.order.status){ case OrderStatus.pending: return Colors.orange; case OrderStatus.confirmed: return Colors.blue; case OrderStatus.preparing: return Colors.purple; case OrderStatus.outForDelivery: return Colors.indigo; case OrderStatus.delivered: return Colors.green; case OrderStatus.cancelled: return Colors.red; } }
  String _f(DateTime dt) { final d = DateTime.now().difference(dt); if (d.inMinutes < 1) return 'Just now'; if (d.inMinutes < 60) return '${d.inMinutes}m ago'; if (d.inHours < 24) return '${d.inHours}h ago'; return '${dt.day}/${dt.month}'; }
  Widget _sr(String l, String v, {bool bold = false, Color? vc}) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Text(l, style: const TextStyle(color: AppTheme.textGrey, fontSize: 13)),
    Text(v, style: TextStyle(fontWeight: bold ? FontWeight.w800 : FontWeight.w600, fontSize: bold ? 15 : 13, color: vc ?? AppTheme.textDark))]);
  @override
  Widget build(BuildContext context) {
    final o = widget.order;
    return Card(margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: _c.withOpacity(0.3), width: 1.5)),
        elevation: 2, child: Column(children: [
          InkWell(onTap: () => setState(() => _exp = !_exp), borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: _c.withOpacity(0.12), borderRadius: BorderRadius.circular(20), border: Border.all(color: _c.withOpacity(0.4))),
                      child: Row(children: [Text(o.status.emoji, style: const TextStyle(fontSize: 12)), const SizedBox(width: 4),
                        Text(o.status.label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _c))])),
                  const Spacer(),
                  Text('#${o.shortId}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppTheme.textDark)),
                  const SizedBox(width: 8),
                  Icon(_exp ? Icons.expand_less : Icons.expand_more, color: AppTheme.textGrey),
                ]),
                const SizedBox(height: 10),
                Row(children: [
                  const Icon(Icons.access_time, size: 13, color: AppTheme.textGrey), const SizedBox(width: 4),
                  Text(_f(o.placedAt), style: const TextStyle(color: AppTheme.textGrey, fontSize: 12)),
                  const Spacer(),
                  Text('${o.totalItemCount} items  ·  ', style: const TextStyle(color: AppTheme.textGrey, fontSize: 12)),
                  Text('₹${o.total.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppTheme.primary)),
                ]),
                if (o.customerName != null) ...[const SizedBox(height: 4), Row(children: [
                  const Icon(Icons.person_outline, size: 13, color: AppTheme.textGrey), const SizedBox(width: 4),
                  Text('${o.customerName}${o.customerPhone != null ? ' · ${o.customerPhone}' : ''}', style: const TextStyle(color: AppTheme.textGrey, fontSize: 12))])],
                if (o.address != null && o.address!.isNotEmpty) ...[const SizedBox(height: 4),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Icon(Icons.location_on_outlined, size: 13, color: AppTheme.textGrey), const SizedBox(width: 4),
                    Expanded(child: Text(o.address!, style: const TextStyle(color: AppTheme.textGrey, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis))])],
              ]))),
          if (_exp) ...[
            const Divider(height: 1),
            Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Order Items', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppTheme.textDark)),
              const SizedBox(height: 8),
              ...o.items.map((item) => Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(children: [
                Text(item.itemEmoji, style: const TextStyle(fontSize: 20)), const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(item.itemName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  if (item.sizeLabel.isNotEmpty) Text(item.sizeLabel, style: const TextStyle(color: AppTheme.textGrey, fontSize: 11)),
                ])),
                Text('×${item.quantity}', style: const TextStyle(color: AppTheme.textGrey, fontSize: 13)), const SizedBox(width: 10),
                Text('₹${item.totalPrice.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppTheme.primary)),
              ]))),
              const Divider(height: 20),
              _sr('Subtotal', '₹${o.subtotal.toStringAsFixed(0)}'), const SizedBox(height: 4),
              _sr('Delivery', o.deliveryFee == 0 ? 'FREE' : '₹${o.deliveryFee.toStringAsFixed(0)}'), const SizedBox(height: 4),
              _sr('Total', '₹${o.total.toStringAsFixed(0)}', bold: true), const SizedBox(height: 4),
              _sr('Payment', o.paymentMethod),
            ])),
            if (o.status != OrderStatus.delivered && o.status != OrderStatus.cancelled)
              Padding(padding: const EdgeInsets.fromLTRB(14, 0, 14, 14), child: _Actions(order: o)),
          ],
        ]));
  }
}

class _Actions extends StatelessWidget {
  final Order order;
  const _Actions({required this.order});
  static const _nl = {
    OrderStatus.pending:        ('Confirm Order',    Icons.check_circle_outline,     Colors.blue),
    OrderStatus.confirmed:      ('Start Preparing',  Icons.soup_kitchen_outlined,    Colors.purple),
    OrderStatus.preparing:      ('Out for Delivery', Icons.delivery_dining_outlined, Colors.indigo),
    OrderStatus.outForDelivery: ('Mark Delivered',   Icons.done_all,                 Colors.green),
  };
  @override
  Widget build(BuildContext context) {
    final op = context.read<OrderProvider>();
    final next = order.status.nextStatuses;
    if (next.isEmpty) return const SizedBox.shrink();
    return Row(children: [
      Expanded(child: ElevatedButton.icon(
          onPressed: () {
            op.updateStatus(order.id, next.first);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Order #${order.shortId} → ${next.first.label}'),
                backgroundColor: Colors.green, behavior: SnackBarBehavior.floating));
          },
          icon: Icon(_nl[order.status]?.$2 ?? Icons.arrow_forward, size: 18),
          label: Text(_nl[order.status]?.$1 ?? next.first.label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          style: ElevatedButton.styleFrom(backgroundColor: _nl[order.status]?.$3 ?? AppTheme.primary, padding: const EdgeInsets.symmetric(vertical: 12)))),
      if (next.contains(OrderStatus.cancelled)) ...[
        const SizedBox(width: 10),
        OutlinedButton.icon(
            onPressed: () => showDialog(context: context, builder: (_) => AlertDialog(
              title: const Text('Cancel Order?'),
              content: Text('Cancel order #${order.shortId}?'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('No')),
                ElevatedButton(onPressed: () { op.cancelOrder(order.id); Navigator.pop(context); },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red), child: const Text('Yes, Cancel')),
              ],
            )),
            icon: const Icon(Icons.cancel_outlined, size: 16, color: Colors.red),
            label: const Text('Cancel', style: TextStyle(color: Colors.red, fontSize: 13)),
            style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red), padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12))),
      ],
    ]);
  }
}

class _Stat extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _Stat(this.label, this.value, this.icon, this.color);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 3))]),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(width: 38, height: 38, decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: color, size: 20)),
      const Spacer(),
      Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: color)),
      Text(label, style: const TextStyle(color: AppTheme.textGrey, fontSize: 12)),
    ]),
  );
}

class _Empty extends StatelessWidget {
  final String emoji, msg;
  const _Empty({required this.emoji, required this.msg});
  @override
  Widget build(BuildContext context) => Center(child: Padding(padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(emoji, style: const TextStyle(fontSize: 56)), const SizedBox(height: 16),
        Text(msg, textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.textGrey, fontSize: 15)),
      ])));
}