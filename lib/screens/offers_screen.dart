// lib/screens/offers_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_provider.dart';
import '../models/menu_item.dart';
import '../utils/app_theme.dart';
import '../utils/menu_data.dart';
import '../widgets/common_widgets.dart';
import 'cart_screen.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  static List<MenuItem> get _largeDeal => [
    ...MenuData.vegPizzas.where((i) => i.subCategory == 'Platinum'),
    ...MenuData.specialPizzas.where((i) => i.subCategory == 'Lover Special' || i.subCategory == 'Ultimate'),
  ];

  static List<MenuItem> get _mediumDeal => [
    ...MenuData.vegPizzas.where((i) => i.subCategory == 'Platinum'),
    ...MenuData.specialPizzas.where((i) => i.subCategory == 'Lover Special' || i.subCategory == 'Ultimate'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offers & Deals 🎉'),
        actions: [
          Consumer<CartProvider>(builder: (_, cart, __) => cart.itemCount == 0 ? const SizedBox.shrink() : Stack(children: [
            IconButton(icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()))),
            Positioned(right: 6, top: 6, child: Container(width: 17, height: 17,
              decoration: const BoxDecoration(color: AppTheme.accent, shape: BoxShape.circle),
              child: Center(child: Text('${cart.itemCount}', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppTheme.dark))))),
          ])),
        ],
      ),
      body: Stack(children: [
        ListView(padding: const EdgeInsets.only(bottom: 100), children: [
          _TopBanner(),
          _DealSection(
            tag: 'WED & FRI ONLY', tagColor: AppTheme.primary,
            title: '🍕 Buy Large Pizza', subtitle: 'Get a FREE Medium Pizza',
            highlight: 'Save up to ₹480!',
            gradient: [const Color(0xFFCC2200), const Color(0xFFFF5500)],
            badges: const ['₹600 · Lover Special', '₹650 · Ultimate'],
            note: 'Categories: Platinum | Lover Special | Ultimate',
            items: _largeDeal, sizeToShow: 'large',
          ),
          const SizedBox(height: 8),
          _DealSection(
            tag: 'WED & FRI ONLY', tagColor: Colors.deepPurple,
            title: '🍕 Buy Medium Pizza', subtitle: 'Get a FREE Small Pizza',
            highlight: 'Save up to ₹220!',
            gradient: [const Color(0xFF6A1B9A), const Color(0xFFAB47BC)],
            badges: const ['₹380 · Platinum', '₹460 · Lover Special', '₹480 · Ultimate'],
            note: 'Categories: Platinum | Lover Special | Ultimate',
            items: _mediumDeal, sizeToShow: 'medium',
          ),
          const SizedBox(height: 8),
          _SimpleOffer(emoji: '🚚', title: 'Free Delivery', subtitle: 'On all orders above ₹500',
            detail: 'Delivery fee waived automatically at checkout on orders ₹500+.',
            badge: 'Orders ₹500+', gradient: [const Color(0xFF2E7D32), const Color(0xFF66BB6A)]),
          const SizedBox(height: 8),
          _SimpleOffer(emoji: '🎁', title: 'Meal Combos', subtitle: 'Complete meals starting ₹110',
            detail: 'Meals 1–5 available. Best value bundles with pizza, sides & drinks.',
            badge: '₹110 onwards', gradient: [const Color(0xFF1565C0), const Color(0xFF42A5F5)]),
          const SizedBox(height: 20),
          _Footer(),
          const SizedBox(height: 20),
        ]),
        FloatingCartBar(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()))),
      ]),
    );
  }
}

class _TopBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final active = now.weekday == DateTime.wednesday || now.weekday == DateTime.friday;
    return Container(
      margin: const EdgeInsets.all(14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
            begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.35), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Row(children: [
        const Text('🎊', style: TextStyle(fontSize: 44)),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Wednesday & Friday Offers', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          const Text('Buy 1 Get 1 Free on select pizzas!', style: TextStyle(color: Colors.white, fontSize: 12)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: active ? Colors.green.shade700 : Colors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(active ? Icons.check_circle : Icons.access_time, color: Colors.white, size: 13),
              const SizedBox(width: 4),
              Text(active ? 'OFFER ACTIVE TODAY! 🔥' : 'Next: Wednesday or Friday',
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
            ]),
          ),
        ])),
      ]),
    );
  }
}

class _DealSection extends StatefulWidget {
  final String tag, title, subtitle, highlight, note, sizeToShow;
  final Color tagColor;
  final List<Color> gradient;
  final List<String> badges;
  final List<MenuItem> items;
  const _DealSection({required this.tag, required this.title, required this.subtitle,
    required this.highlight, required this.note, required this.sizeToShow,
    required this.tagColor, required this.gradient, required this.badges, required this.items});
  @override
  State<_DealSection> createState() => _DealSectionState();
}

class _DealSectionState extends State<_DealSection> {
  bool _show = false;
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: widget.gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: widget.gradient.first.withOpacity(0.28), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white30)),
            child: Text(widget.tag, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.8)),
          ),
          const SizedBox(height: 10),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(widget.title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
              Text(widget.subtitle, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
            ])),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Text(widget.highlight, style: TextStyle(color: widget.gradient.last, fontSize: 11, fontWeight: FontWeight.w900)),
            ),
          ]),
          const SizedBox(height: 12),
          const Divider(color: Colors.white24),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 6, children: widget.badges.map((p) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white30)),
            child: Text(p, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
          )).toList()),
          const SizedBox(height: 8),
          Text(widget.note, style: const TextStyle(color: Colors.white60, fontSize: 11)),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () => setState(() => _show = !_show),
            child: Container(
              width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 11),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(_show ? Icons.expand_less : Icons.local_pizza_outlined, color: widget.gradient.first, size: 18),
                const SizedBox(width: 6),
                Text(_show ? 'Hide eligible pizzas' : 'View ${widget.items.length} eligible pizzas →',
                    style: TextStyle(color: widget.gradient.first, fontWeight: FontWeight.w800, fontSize: 13)),
              ]),
            ),
          ),
        ])),
      ),
      if (_show) ...[
        const SizedBox(height: 4),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 14),
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(14),
            border: Border.all(color: widget.gradient.first.withOpacity(0.2)),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
          ),
          child: Column(children: widget.items.map((item) => _PizzaRow(item: item, size: widget.sizeToShow)).toList()),
        ),
      ],
    ]);
  }
}

class _PizzaRow extends StatelessWidget {
  final MenuItem item;
  final String size;
  const _PizzaRow({required this.item, required this.size});
  String get _sl { switch(size){ case 'large': return '13" Large'; case 'medium': return '10" Medium'; default: return '7" Regular'; } }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(children: [
        Container(width: 46, height: 46,
          decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(10)),
          child: Center(child: Text(item.emoji, style: const TextStyle(fontSize: 24)))),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(item.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppTheme.textDark), maxLines: 1, overflow: TextOverflow.ellipsis),
          Row(children: [
            SubCategoryBadge(label: item.subCategory),
            const SizedBox(width: 6),
            Text(_sl, style: const TextStyle(color: AppTheme.textGrey, fontSize: 10)),
          ]),
        ])),
        const SizedBox(width: 8),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('₹${item.getPrice(size).toStringAsFixed(0)}',
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppTheme.primary)),
          const SizedBox(height: 4),
          QuantityControl(item: item, size: size, compact: true),
        ]),
      ]),
    );
  }
}

class _SimpleOffer extends StatelessWidget {
  final String emoji, title, subtitle, detail, badge;
  final List<Color> gradient;
  const _SimpleOffer({required this.emoji, required this.title, required this.subtitle,
    required this.detail, required this.badge, required this.gradient});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: gradient.first.withOpacity(0.25), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(children: [
        Text(emoji, style: const TextStyle(fontSize: 42)),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900)),
          const SizedBox(height: 3),
          Text(subtitle, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(detail, style: const TextStyle(color: Colors.white70, fontSize: 11, height: 1.5)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white30)),
            child: Text(badge, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ])),
      ]),
    );
  }
}

class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
      child: Column(children: [
        const Text('📞 Order Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.textDark)),
        const SizedBox(height: 6),
        const Text('9878394950', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppTheme.primary)),
        const SizedBox(height: 4),
        const Text('Home Delivery Available', style: TextStyle(color: AppTheme.textGrey, fontSize: 12)),
        const Divider(height: 20),
        const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.qr_code, size: 16, color: AppTheme.textGrey),
          SizedBox(width: 6),
          Text('9878394950@okbizaxis', style: TextStyle(color: AppTheme.textGrey, fontSize: 12)),
        ]),
      ]),
    );
  }
}
