// lib/screens/pizza_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/menu_item.dart';
import '../models/cart_provider.dart';
import '../utils/app_theme.dart';
import '../utils/menu_data.dart';
import '../widgets/common_widgets.dart';
import 'cart_screen.dart';

class PizzaScreen extends StatefulWidget {
  const PizzaScreen({super.key});
  @override
  State<PizzaScreen> createState() => _PizzaScreenState();
}

class _PizzaScreenState extends State<PizzaScreen> with SingleTickerProviderStateMixin {
  late TabController _tab;
  static const _tabs = ['All', 'Silver', 'Gold', 'Platinum', 'Special', 'Mania'];

  List<MenuItem> _items(String tab) {
    final all = [...MenuData.vegPizzas, ...MenuData.specialPizzas];
    if (tab == 'All')     return all;
    if (tab == 'Special') return MenuData.specialPizzas.where((i) => i.subCategory == 'Special' || i.subCategory == 'Lover Special').toList();
    if (tab == 'Mania')   return MenuData.specialPizzas.where((i) => i.subCategory == 'Mania').toList();
    return all.where((i) => i.subCategory?.toLowerCase() == tab.toLowerCase()).toList();
  }

  @override
  void initState() { super.initState(); _tab = TabController(length: _tabs.length, vsync: this); }
  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🍕 Pizza Menu'),
        bottom: TabBar(
          controller: _tab, isScrollable: true,
          labelColor: Colors.white, unselectedLabelColor: Colors.white60,
          indicatorColor: AppTheme.accent, indicatorWeight: 3,
          tabs: _tabs.map((t) => Tab(text: t)).toList(),
        ),
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
        TabBarView(controller: _tab, children: _tabs.map((tab) {
          final items = _items(tab);
          if (items.isEmpty) return const Center(child: Text('No items', style: TextStyle(color: AppTheme.textGrey)));
          return ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 100),
            itemCount: items.length,
            itemBuilder: (ctx, i) => MenuItemCard(item: items[i]),
          );
        }).toList()),
        FloatingCartBar(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()))),
      ]),
    );
  }
}
