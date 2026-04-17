import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/auth_provider.dart';
import '../models/cart_provider.dart';
import '../models/order_provider.dart';
import '../models/order_model.dart';
import '../utils/app_theme.dart';
import 'cart_screen.dart';
import 'admin_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int  _langIdx   = 0;
  bool _notif     = true;
  bool _orderUpd  = true;
  int  _loyPts    = 0;
  bool _ratingDone= false;
  final List<String> _savedAddr = ['', '', ''];
  static const _langs = ['English', 'Hindi', 'Punjabi'];

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F8),
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 230,
          pinned: true, floating: false,
          backgroundColor: AppTheme.primary,
          actions: [
            Consumer<CartProvider>(builder: (_, cart, __) => cart.itemCount == 0
                ? const SizedBox.shrink()
                : Stack(children: [
              IconButton(icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()))),
              Positioned(right: 6, top: 6, child: Container(width: 17, height: 17,
                  decoration: const BoxDecoration(color: AppTheme.accent, shape: BoxShape.circle),
                  child: Center(child: Text('${cart.itemCount}', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppTheme.dark))))),
            ])),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(gradient: LinearGradient(
                  colors: [Color(0xFF8B0000), AppTheme.primary, Color(0xFFCC4400)],
                  begin: Alignment.topLeft, end: Alignment.bottomRight)),
              child: SafeArea(child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SizedBox(height: 8),
                  Row(children: [
                    GestureDetector(
                      onTap: () => auth.isLoggedIn ? _editProfile(context, auth) : _goLogin(context),
                      child: Stack(children: [
                        Container(width: 76, height: 76,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2), shape: BoxShape.circle,
                                border: Border.all(color: Colors.white54, width: 2.5)),
                            child: Center(child: Text(
                                auth.isLoggedIn ? auth.displayName[0].toUpperCase() : '👤',
                                style: TextStyle(fontSize: auth.isLoggedIn ? 32 : 36,
                                    color: Colors.white, fontWeight: FontWeight.w900)))),
                        Positioned(right: 0, bottom: 0, child: Container(width: 24, height: 24,
                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                            child: Icon(auth.isLoggedIn ? Icons.edit : Icons.login,
                                size: 14, color: AppTheme.primary))),
                      ]),
                    ),
                    const SizedBox(width: 16),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(auth.isLoggedIn ? auth.displayName : 'Guest User',
                          style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900),
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      if (auth.isLoggedIn && auth.displayPhone.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Text(auth.displayPhone, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                      ],
                      if (auth.isLoggedIn && auth.displayEmail.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(auth.displayEmail, style: const TextStyle(color: Colors.white60, fontSize: 11),
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                      const SizedBox(height: 8),
                      if (auth.isAdmin) _adminBadge()
                      else if (auth.isLoggedIn) _loyaltyBadge()
                      else GestureDetector(
                            onTap: () => _goLogin(context),
                            child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                                child: const Text('Login / Sign Up',
                                    style: TextStyle(color: AppTheme.primary, fontSize: 12, fontWeight: FontWeight.w800)))),
                    ])),
                  ]),
                ]),
              )),
            ),
          ),
        ),

        SliverList(delegate: SliverChildListDelegate([
          const SizedBox(height: 12),
          _label('MY ACCOUNT'),
          if (!auth.isLoggedIn)
            _tile(icon: Icons.login_rounded, bg: AppTheme.primary,
                title: 'Login to Your Account',
                sub: 'Access orders, addresses & more',
                onTap: () => _goLogin(context))
          else ...[
            _MyOrdersTile(),
            const SizedBox(height: 3),
            _tile(icon: Icons.person_outline, bg: Colors.blue,
                title: 'Edit Profile',
                sub: auth.displayName.isEmpty ? 'Tap to set up profile' : auth.displayName,
                onTap: () => _editProfile(context, auth)),
            const SizedBox(height: 3),
            _tile(icon: Icons.location_on_outlined, bg: Colors.teal,
                title: 'Delivery Addresses',
                sub: _savedAddr[0].isEmpty ? 'Add your delivery address' : _savedAddr[0],
                onTap: () => _editAddresses(context)),
            const SizedBox(height: 3),
            _tile(icon: Icons.payment_outlined, bg: Colors.indigo,
                title: 'Payment Methods', sub: 'UPI · Cards · Cash on Delivery',
                onTap: () => _paymentSheet(context)),
          ],

          _label('OFFERS & LOYALTY'),
          _LoyaltyCard(points: _loyPts),
          const SizedBox(height: 3),
          _tile(icon: Icons.local_offer_outlined, bg: Colors.orange,
              title: 'Coupons & Promo Codes', sub: 'Enter code to get discounts',
              onTap: () => _couponsSheet(context)),

          _label('RATE & REVIEW'),
          _RateCard(done: _ratingDone, onRate: (s) {
            setState(() { _ratingDone = true; _loyPts += 10; });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Thanks for $s ⭐! +10 loyalty points 🎉'),
                backgroundColor: Colors.amber.shade700, behavior: SnackBarBehavior.floating));
          }),

          _label('CONTACT & SUPPORT'),
          _ContactCard(),

          _label('ABOUT RESTAURANT'),
          const _AboutCard(),

          _label('SETTINGS'),
          _SettingsCard(
            notif: _notif, orderUpd: _orderUpd,
            langIdx: _langIdx, langs: _langs,
            onLang:  (i) => setState(() { _langIdx = i; }),
            onNotif: (v) => setState(() => _notif  = v),
            onOrder: (v) => setState(() => _orderUpd = v),
          ),

          if (auth.isAdmin) ...[
            _label('ADMIN'),
            _tile(icon: Icons.admin_panel_settings_outlined, bg: AppTheme.primary,
                title: 'Admin Panel',
                sub: 'View & manage all customer orders',
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminDashboard())),
                trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                    child: const Text('OPEN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.green)))),
          ],

          if (auth.isLoggedIn) ...[
            _label('ACCOUNT'),
            _tile(icon: Icons.logout_rounded, bg: Colors.red,
                title: 'Logout',
                sub: 'You will need to login again',
                onTap: () => _confirmLogout(context, auth)),
          ],

          const SizedBox(height: 28),
          Center(child: Column(children: [
            const Text('🍕', style: TextStyle(fontSize: 32)),
            const SizedBox(height: 6),
            const Text('Pizza Lovers 39', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppTheme.textDark)),
            const SizedBox(height: 2),
            const Text('Version 1.0.0', style: TextStyle(color: AppTheme.textGrey, fontSize: 12)),
            const SizedBox(height: 3),
            Text('Made with ❤️ for pizza lovers', style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
          ])),
          const SizedBox(height: 30),
        ])),
      ]),
    );
  }

  Widget _adminBadge() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: AppTheme.accent, borderRadius: BorderRadius.circular(20)),
    child: const Row(mainAxisSize: MainAxisSize.min, children: [
      Text('👑', style: TextStyle(fontSize: 12)), SizedBox(width: 4),
      Text('ADMIN', style: TextStyle(color: AppTheme.dark, fontSize: 11, fontWeight: FontWeight.w900)),
    ]),
  );

  Widget _loyaltyBadge() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white30)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      const Text('⭐', style: TextStyle(fontSize: 12)), const SizedBox(width: 4),
      Text('$_loyPts pts', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
    ]),
  );

  void _goLogin(BuildContext ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const LoginScreen()));

  void _confirmLogout(BuildContext ctx, AuthProvider auth) {
    showDialog(context: ctx, builder: (_) => AlertDialog(
      title: const Text('Logout?'),
      content: const Text('Are you sure you want to logout?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(_), child: const Text('Cancel')),
        ElevatedButton(onPressed: () { Navigator.pop(_); auth.logout(); },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red), child: const Text('Logout')),
      ],
    ));
  }

  Widget _label(String t) => Padding(padding: const EdgeInsets.fromLTRB(16, 18, 16, 6),
      child: Text(t, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppTheme.textGrey, letterSpacing: 1.3)));

  Widget _tile({required IconData icon, required Color bg, required String title, required String sub, required VoidCallback onTap, Widget? trailing}) =>
      GestureDetector(onTap: onTap, child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))]),
        child: Row(children: [
          Container(width: 42, height: 42, decoration: BoxDecoration(color: bg.withOpacity(0.12), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: bg, size: 21)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppTheme.textDark)),
            Text(sub,   style: const TextStyle(color: AppTheme.textGrey, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
          ])),
          trailing ?? const Icon(Icons.chevron_right, color: AppTheme.textGrey, size: 20),
        ]),
      ));

  void _editProfile(BuildContext ctx, AuthProvider auth) {
    final nc = TextEditingController(text: auth.displayName);
    final pc = TextEditingController(text: auth.displayPhone);
    final ec = TextEditingController(text: auth.displayEmail);
    _sheet(ctx, 'Edit Profile', Column(mainAxisSize: MainAxisSize.min, children: [
      _tf(nc, 'Full Name',    Icons.person_outline,  TextInputType.name),
      const SizedBox(height: 12),
      _tf(pc, 'Phone Number', Icons.phone_outlined,  TextInputType.phone),
      const SizedBox(height: 12),
      _tf(ec, 'Email',        Icons.email_outlined,  TextInputType.emailAddress),
      const SizedBox(height: 20),
      _btn('Save Profile', () async {
        await auth.updateProfile(name: nc.text, phone: pc.text, email: ec.text);
        if (mounted) {
          Navigator.pop(ctx);
          ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('✅ Profile updated!'), behavior: SnackBarBehavior.floating));
        }
      }),
    ]));
  }

  void _editAddresses(BuildContext ctx) {
    final a1 = TextEditingController(text: _savedAddr[0]);
    final a2 = TextEditingController(text: _savedAddr[1]);
    final a3 = TextEditingController(text: _savedAddr[2]);
    _sheet(ctx, 'Delivery Addresses', Column(mainAxisSize: MainAxisSize.min, children: [
      const Text('Save up to 3 addresses', style: TextStyle(color: AppTheme.textGrey, fontSize: 13)),
      const SizedBox(height: 14),
      _af(a1, '🏠  Home Address'), const SizedBox(height: 12),
      _af(a2, '💼  Work Address'), const SizedBox(height: 12),
      _af(a3, '📍  Other Address'), const SizedBox(height: 20),
      _btn('Save Addresses', () { setState(() { _savedAddr[0] = a1.text.trim(); _savedAddr[1] = a2.text.trim(); _savedAddr[2] = a3.text.trim(); }); Navigator.pop(ctx); }),
    ]));
  }

  void _paymentSheet(BuildContext ctx) {
    _sheet(ctx, 'Payment Methods', Column(mainAxisSize: MainAxisSize.min, children: [
      _pr('📱', 'UPI / QR Pay',        'GPay · PhonePe · Paytm'),
      const Divider(height: 22),
      _pr('💳', 'Credit / Debit Card', 'Visa · Mastercard · RuPay'),
      const Divider(height: 22),
      _pr('💰', 'Cash on Delivery',    'Pay at your doorstep'),
      const SizedBox(height: 14),
      GestureDetector(
        onTap: () { Clipboard.setData(const ClipboardData(text: '9878394950@okbizaxis')); Navigator.pop(ctx); ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('UPI ID copied!'), behavior: SnackBarBehavior.floating)); },
        child: Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.green.withOpacity(0.07), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.green.withOpacity(0.25))),
            child: const Row(children: [
              Icon(Icons.qr_code, color: Colors.green), SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('UPI ID', style: TextStyle(color: AppTheme.textGrey, fontSize: 11)),
                Text('9878394950@okbizaxis', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppTheme.textDark)),
              ])),
              Icon(Icons.copy, color: Colors.green, size: 18),
            ])),
      ),
      const SizedBox(height: 8),
    ]));
  }

  void _couponsSheet(BuildContext ctx) {
    final ctrl = TextEditingController();
    final coupons = [('🍕','PIZZA10','10% off on all pizzas'),('🎁','FIRST50','₹50 off on first order'),('🚚','FREEDELIVERY','Free delivery on any order'),('🎉','WEDOFFER','Extra 5% on Wed & Fri')];
    showModalBottomSheet(context: ctx, isScrollControlled: true, backgroundColor: Colors.white, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        builder: (_) => StatefulBuilder(builder: (sCtx, ss) => Padding(padding: EdgeInsets.only(left: 20, right: 20, top: 24, bottom: MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Coupons & Promo Codes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppTheme.textDark)),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: TextField(controller: ctrl, textCapitalization: TextCapitalization.characters, decoration: InputDecoration(hintText: 'Enter promo code', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12)))),
              const SizedBox(width: 10),
              ElevatedButton(onPressed: () { Navigator.pop(sCtx); ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(ctrl.text.trim().isEmpty ? 'Enter a coupon code' : '🎉 Coupon applied!'), behavior: SnackBarBehavior.floating)); }, child: const Text('Apply')),
            ]),
            const SizedBox(height: 18),
            const Text('Available Coupons', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppTheme.textDark)),
            const SizedBox(height: 10),
            ...coupons.map((c) => GestureDetector(onTap: () => ss(() => ctrl.text = c.$2),
                child: Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.primary.withOpacity(0.2))),
                    child: Row(children: [Text(c.$1, style: const TextStyle(fontSize: 22)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(c.$2, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppTheme.primary)), Text(c.$3, style: const TextStyle(color: AppTheme.textGrey, fontSize: 12))])), const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.textGrey)])))),
          ]))));
  }

  void _sheet(BuildContext ctx, String title, Widget content) {
    showModalBottomSheet(context: ctx, isScrollControlled: true, backgroundColor: Colors.white, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        builder: (_) => Padding(padding: EdgeInsets.only(left: 20, right: 20, top: 24, bottom: MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppTheme.textDark)), const SizedBox(height: 18), content])));
  }

  Widget _tf(TextEditingController c, String label, IconData icon, TextInputType type) =>
      TextFormField(controller: c, keyboardType: type, decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: AppTheme.surface));
  Widget _af(TextEditingController c, String hint) => TextFormField(controller: c, maxLines: 2, decoration: InputDecoration(hintText: hint, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: AppTheme.surface));
  Widget _pr(String e, String t, String s) => Row(children: [Text(e, style: const TextStyle(fontSize: 26)), const SizedBox(width: 12), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(t, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppTheme.textDark)), Text(s, style: const TextStyle(color: AppTheme.textGrey, fontSize: 12))])]);
  Widget _btn(String l, VoidCallback f) => SizedBox(width: double.infinity, child: ElevatedButton(onPressed: f, style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 15)), child: Text(l, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800))));
}

class _MyOrdersTile extends StatelessWidget {
  Color _c(OrderStatus s) { switch(s){ case OrderStatus.pending: return Colors.orange; case OrderStatus.confirmed: return Colors.blue; case OrderStatus.preparing: return Colors.purple; case OrderStatus.outForDelivery: return Colors.indigo; case OrderStatus.delivered: return Colors.green; case OrderStatus.cancelled: return Colors.red; } }
  @override
  Widget build(BuildContext context) {
    final op   = context.watch<OrderProvider>();
    final last = op.orders.isNotEmpty ? op.orders.first : null;
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _OrdersHistory())),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))]),
        child: Row(children: [
          Container(width: 42, height: 42, decoration: BoxDecoration(color: Colors.orange.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.receipt_long_outlined, color: Colors.orange, size: 21)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('My Orders', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppTheme.textDark)),
            Text(op.totalOrders == 0 ? 'No orders yet' : '${op.totalOrders} order${op.totalOrders > 1 ? 's' : ''} placed',
                style: const TextStyle(color: AppTheme.textGrey, fontSize: 12)),
          ])),
          if (last != null) Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: _c(last.status).withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
              child: Text('${last.status.emoji} ${last.status.label}', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: _c(last.status)))),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, color: AppTheme.textGrey, size: 20),
        ]),
      ),
    );
  }
}

class _LoyaltyCard extends StatelessWidget {
  final int points;
  const _LoyaltyCard({required this.points});
  @override
  Widget build(BuildContext context) {
    final pct = (points % 100) / 100.0;
    return Container(margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 2), padding: const EdgeInsets.all(16), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFFFB300), Color(0xFFFF6F00)], begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [const Text('⭐', style: TextStyle(fontSize: 22)), const SizedBox(width: 8), const Text('Loyalty Points', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)), const Spacer(), Text('$points pts', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20))]), const SizedBox(height: 10), ClipRRect(borderRadius: BorderRadius.circular(10), child: LinearProgressIndicator(value: pct, minHeight: 8, backgroundColor: Colors.white.withOpacity(0.3), valueColor: const AlwaysStoppedAnimation<Color>(Colors.white))), const SizedBox(height: 6), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('${points % 100}/100 to next reward', style: const TextStyle(color: Colors.white70, fontSize: 11)), const Text('Rate us → +10 pts', style: TextStyle(color: Colors.white70, fontSize: 11))])]),
    );
  }
}

class _RateCard extends StatefulWidget {
  final bool done;
  final ValueChanged<int> onRate;
  const _RateCard({required this.done, required this.onRate});
  @override
  State<_RateCard> createState() => _RateCardState();
}
class _RateCardState extends State<_RateCard> {
  int _s = 0;
  @override
  Widget build(BuildContext context) => Container(margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 2), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))]),
      child: widget.done ? const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text('🎉', style: TextStyle(fontSize: 24)), SizedBox(width: 10), Text('Thanks for rating us!', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.green))])
          : Column(children: [const Row(children: [Icon(Icons.star_rounded, color: Colors.amber, size: 20), SizedBox(width: 8), Text('Rate Your Experience', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppTheme.textDark))]), const SizedBox(height: 12), Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(5, (i) => GestureDetector(onTap: () => setState(() => _s = i + 1), child: Padding(padding: const EdgeInsets.symmetric(horizontal: 5), child: Icon(i < _s ? Icons.star_rounded : Icons.star_outline_rounded, color: Colors.amber, size: 40))))), if (_s > 0) ...[const SizedBox(height: 12), SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => widget.onRate(_s), style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)), child: Text('Submit $_s Star${_s > 1 ? 's' : ''}', style: const TextStyle(fontWeight: FontWeight.w700))))]]));
}

class _ContactCard extends StatelessWidget {
  void _copy(BuildContext ctx, String t, String m) { Clipboard.setData(ClipboardData(text: t)); ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(m), behavior: SnackBarBehavior.floating)); }
  @override
  Widget build(BuildContext context) => Container(margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 2), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))]),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Row(children: [Icon(Icons.headset_mic_outlined, color: Colors.teal, size: 20), SizedBox(width: 8), Text('Contact & Support', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppTheme.textDark))]), const SizedBox(height: 14), Row(children: [Expanded(child: _btn(context, '📞', 'Call Now',  Colors.green, () => _copy(context, '9878394950', '📞 Number copied!'))), const SizedBox(width: 8), Expanded(child: _btn(context, '💬', 'WhatsApp', const Color(0xFF25D366), () => _copy(context, '+919878394950', '💬 Copied!'))), const SizedBox(width: 8), Expanded(child: _btn(context, '📍', 'Location', Colors.red, () => _copy(context, 'Pizza Lovers 39, Sector 39', '📍 Copied!'))), const SizedBox(width: 8), Expanded(child: _btn(context, '✉️', 'Email', Colors.blue, () => _copy(context, 'pizzalovers39@gmail.com', '✉️ Email copied!')))]), const SizedBox(height: 12), Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(10)), child: const Row(children: [Icon(Icons.access_time_outlined, size: 15, color: AppTheme.textGrey), SizedBox(width: 8), Text('Support: Mon–Sun  11:00 AM – 11:00 PM', style: TextStyle(color: AppTheme.textGrey, fontSize: 12))]))]),
  );
  Widget _btn(BuildContext ctx, String e, String l, Color c, VoidCallback f) => GestureDetector(onTap: f, child: Container(padding: const EdgeInsets.symmetric(vertical: 10), decoration: BoxDecoration(color: c.withOpacity(0.1), borderRadius: BorderRadius.circular(10), border: Border.all(color: c.withOpacity(0.25))), child: Column(children: [Text(e, style: const TextStyle(fontSize: 20)), const SizedBox(height: 3), Text(l, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: c))])));
}

class _AboutCard extends StatefulWidget {
  const _AboutCard();
  @override
  State<_AboutCard> createState() => _AboutCardState();
}
class _AboutCardState extends State<_AboutCard> {
  bool _open = false;
  @override
  Widget build(BuildContext context) => Container(margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 2), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))]),
    child: Column(children: [GestureDetector(onTap: () => setState(() => _open = !_open), child: Padding(padding: const EdgeInsets.all(14), child: Row(children: [Container(width: 42, height: 42, decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: const Center(child: Text('🍕', style: TextStyle(fontSize: 22)))), const SizedBox(width: 12), const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('About Pizza Lovers 39', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppTheme.textDark)), Text('Timings, location, our story', style: TextStyle(color: AppTheme.textGrey, fontSize: 12))])), Icon(_open ? Icons.expand_less : Icons.expand_more, color: AppTheme.textGrey)]))),
      if (_open) ...[const Divider(height: 1), Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Our Story', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppTheme.textDark)), const SizedBox(height: 8), const Text('Pizza Lovers 39 was founded with one mission — to bring authentic, freshly hand-crafted pizzas to your doorstep. Every pizza is made using the finest ingredients with our signature sauces.', style: TextStyle(color: AppTheme.textGrey, fontSize: 13, height: 1.6)), const SizedBox(height: 16), _ir(Icons.location_on_outlined,    Colors.red,    'Location', 'Manakpur, Rajpura'), const Divider(height: 18), _ir(Icons.phone_outlined,           Colors.green,  'Phone',    '9878394950'), const Divider(height: 18), _ir(Icons.access_time_outlined,     Colors.orange, 'Hours',    'Mon–Sun  11 AM – 11 PM'), const Divider(height: 18), _ir(Icons.delivery_dining_outlined, Colors.teal,   'Delivery', 'Free on orders above ₹500'), const Divider(height: 18), _ir(Icons.qr_code,                  Colors.indigo, 'UPI',      '9878394950@okbizaxis'), const SizedBox(height: 16), const Text('Specialities', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppTheme.textDark)), const SizedBox(height: 10), Wrap(spacing: 7, runSpacing: 7, children: ['🍕 Veg Pizzas','🔥 Peri Peri','👑 Ultimate','❤️ Lover Special','🍔 Burgers','🌮 Tacos','🍝 Pasta','🧋 Shakes'].map((t) => Container(padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5), decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.07), borderRadius: BorderRadius.circular(20), border: Border.all(color: AppTheme.primary.withOpacity(0.2))), child: Text(t, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.primary)))).toList())]))],
    ]),
  );
  Widget _ir(IconData icon, Color c, String l, String v) => Row(children: [Container(width: 34, height: 34, decoration: BoxDecoration(color: c.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: c, size: 17)), const SizedBox(width: 12), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(l, style: const TextStyle(color: AppTheme.textGrey, fontSize: 11)), Text(v, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppTheme.textDark))])]);
}

class _SettingsCard extends StatelessWidget {
  final bool notif, orderUpd; final int langIdx; final List<String> langs; final ValueChanged<int> onLang; final ValueChanged<bool> onNotif, onOrder;
  const _SettingsCard({required this.notif, required this.orderUpd, required this.langIdx, required this.langs, required this.onLang, required this.onNotif, required this.onOrder});
  @override
  Widget build(BuildContext context) => Container(margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 2), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))]),
    child: Column(children: [_sw(Icons.notifications_outlined, Colors.deepPurple, 'Push Notifications', 'Offers, deals & updates', notif, onNotif), const Divider(height: 1, indent: 68), _sw(Icons.local_shipping_outlined, Colors.teal, 'Order Updates', 'Track your order status live', orderUpd, onOrder), const Divider(height: 1, indent: 68), Padding(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), child: Row(children: [Container(width: 42, height: 42, decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.language_outlined, color: Colors.blue, size: 21)), const SizedBox(width: 12), const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Language', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppTheme.textDark)), Text('Choose your preferred language', style: TextStyle(color: AppTheme.textGrey, fontSize: 12))])), DropdownButton<int>(value: langIdx, underline: const SizedBox.shrink(), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppTheme.primary), items: langs.asMap().entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(), onChanged: (i) { if (i != null) onLang(i); })]))]),
  );
  Widget _sw(IconData icon, Color c, String t, String s, bool v, ValueChanged<bool> f) => Padding(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), child: Row(children: [Container(width: 42, height: 42, decoration: BoxDecoration(color: c.withOpacity(0.12), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: c, size: 21)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(t, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppTheme.textDark)), Text(s, style: const TextStyle(color: AppTheme.textGrey, fontSize: 12))])), Switch(value: v, onChanged: f, activeColor: AppTheme.primary)]));
}

class _OrdersHistory extends StatelessWidget {
  const _OrdersHistory();
  Color _c(OrderStatus s) { switch(s){ case OrderStatus.pending: return Colors.orange; case OrderStatus.confirmed: return Colors.blue; case OrderStatus.preparing: return Colors.purple; case OrderStatus.outForDelivery: return Colors.indigo; case OrderStatus.delivered: return Colors.green; case OrderStatus.cancelled: return Colors.red; } }
  String _f(DateTime dt) { final d = DateTime.now().difference(dt); if (d.inMinutes < 1) return 'Just now'; if (d.inMinutes < 60) return '${d.inMinutes}m ago'; if (d.inHours < 24) return '${d.inHours}h ago'; return '${dt.day}/${dt.month}'; }
  @override
  Widget build(BuildContext context) {
    final op = context.watch<OrderProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: op.orders.isEmpty
          ? const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text('📦', style: TextStyle(fontSize: 60)), SizedBox(height: 16), Text('No orders yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textDark)), SizedBox(height: 6), Text('Your orders will appear here', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textGrey))]))
          : ListView.builder(padding: const EdgeInsets.all(12), itemCount: op.orders.length,
          itemBuilder: (ctx, i) {
            final o = op.orders[i]; final color = _c(o.status);
            return Card(margin: const EdgeInsets.only(bottom: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide(color: color.withOpacity(0.25), width: 1)), elevation: 2, child: Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Text('Order #${o.shortId}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppTheme.textDark)), const Spacer(), Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)), child: Text('${o.status.emoji} ${o.status.label}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color)))]), const SizedBox(height: 6), Text(o.items.map((it) => '${it.itemEmoji} ${it.itemName} ×${it.quantity}').join('  •  '), style: const TextStyle(color: AppTheme.textGrey, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis), const Divider(height: 16), Row(children: [const Icon(Icons.access_time, size: 13, color: AppTheme.textGrey), const SizedBox(width: 4), Text(_f(o.placedAt), style: const TextStyle(color: AppTheme.textGrey, fontSize: 12)), const Spacer(), Text('${o.totalItemCount} item${o.totalItemCount > 1 ? 's' : ''}  ·  ', style: const TextStyle(color: AppTheme.textGrey, fontSize: 12)), Text('₹${o.total.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppTheme.primary))])])));
          }),
    );
  }
}
