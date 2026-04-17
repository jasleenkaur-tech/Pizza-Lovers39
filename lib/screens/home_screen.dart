// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_provider.dart';
import '../models/menu_item.dart';
import '../utils/app_theme.dart';
import '../utils/menu_data.dart';
import '../widgets/common_widgets.dart';
import 'cart_screen.dart';
import 'menu_screen.dart';
import 'offers_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        CustomScrollView(slivers: [
          _appBar(context),
          SliverToBoxAdapter(child: _categories(context)),
          SliverToBoxAdapter(child: _wedFriOffer(context)),
          SliverToBoxAdapter(child: _bestsellers(context)),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ]),
        FloatingCartBar(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()))),
      ]),
    );
  }

  Widget _appBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 170, floating: false, pinned: true, backgroundColor: AppTheme.primary,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [Color(0xFF8B0000), AppTheme.primary, Color(0xFFCC4400)],
          )),
          child: SafeArea(child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 8),
              Row(children: [
                Container(width: 48, height: 48,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: const Center(child: Text('🍕', style: TextStyle(fontSize: 28)))),
                const SizedBox(width: 12),
                const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('PIZZA LOVERS 39', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 1)),
                  Text('Authentic Pizzas & More', style: TextStyle(color: Colors.white70, fontSize: 12)),
                ])),
                Consumer<CartProvider>(builder: (_, cart, __) => Stack(children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 28),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()))),
                  if (cart.itemCount > 0)
                    Positioned(right: 6, top: 6,
                      child: Container(width: 18, height: 18,
                        decoration: const BoxDecoration(color: AppTheme.accent, shape: BoxShape.circle),
                        child: Center(child: Text('${cart.itemCount}',
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.dark))))),
                ])),
              ]),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                child: const Row(children: [
                  Icon(Icons.location_on, color: Colors.white70, size: 16),
                  SizedBox(width: 6),
                  Expanded(child: Text('Home Delivery Available', style: TextStyle(color: Colors.white, fontSize: 13))),
                  Icon(Icons.phone, color: Colors.white70, size: 16),
                  SizedBox(width: 4),
                  Text('9878394950', style: TextStyle(color: Colors.white, fontSize: 12)),
                ]),
              ),
            ]),
          )),
        ),
      ),
    );
  }

  Widget _categories(BuildContext context) {
    final cats = [
      {'label': 'Veg Pizza',  'emoji': '🍕', 'cat': MenuCategory.vegPizza},
      {'label': 'Special',    'emoji': '👑', 'cat': MenuCategory.special},
      {'label': 'Burgers',    'emoji': '🍔', 'cat': MenuCategory.burger},
      {'label': 'Pasta',      'emoji': '🍝', 'cat': MenuCategory.pasta},
      {'label': 'Shakes',     'emoji': '🧋', 'cat': MenuCategory.shakes},
      {'label': 'Wraps',      'emoji': '🌯', 'cat': MenuCategory.wraps},
      {'label': 'Fries',      'emoji': '🍟', 'cat': MenuCategory.fries},
      {'label': 'Sandwich',   'emoji': '🥪', 'cat': MenuCategory.sandwich},
      {'label': 'Tacos',      'emoji': '🌮', 'cat': MenuCategory.tacos},
      {'label': 'Meals',      'emoji': '🎁', 'cat': MenuCategory.meals},
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SectionHeader(title: 'Categories', subtitle: 'What are you craving?'),
      SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: cats.length,
          itemBuilder: (ctx, i) => GestureDetector(
            onTap: () => Navigator.push(ctx, MaterialPageRoute(
                builder: (_) => MenuScreen(initialCategory: cats[i]['cat'] as MenuCategory))),
            child: Container(
              width: 76, margin: const EdgeInsets.only(right: 10),
              child: Column(children: [
                Container(
                  width: 62, height: 62,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
                  ),
                  child: Center(child: Text(cats[i]['emoji'] as String, style: const TextStyle(fontSize: 28))),
                ),
                const SizedBox(height: 6),
                Text(cats[i]['label'] as String, textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: AppTheme.textDark)),
              ]),
            ),
          ),
        ),
      ),
    ]);
  }

  Widget _wedFriOffer(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OffersScreen())),
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 16, 12, 0),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF3CD),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFFFD700), width: 1.5),
        ),
        child: const Row(children: [
          Text('🎊', style: TextStyle(fontSize: 30)),
          SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Wednesday & Friday Offers!',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Color(0xFF856404))),
            SizedBox(height: 2),
            Text('Buy 1 Get 1 Free on select Pizzas',
                style: TextStyle(fontSize: 12, color: Color(0xFF856404))),
          ])),
          Icon(Icons.chevron_right, color: Color(0xFF856404)),
        ]),
      ),
    );
  }

  Widget _bestsellers(BuildContext context) {
    final items = MenuData.allItems.where((i) => i.isBestseller).take(6).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SectionHeader(title: '⭐ Bestsellers', subtitle: 'Most loved by our customers'),
      ...items.map((item) => MenuItemCard(item: item)),
    ]);
  }
}
