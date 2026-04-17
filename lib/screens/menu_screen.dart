// lib/screens/menu_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/menu_item.dart';
import '../models/cart_provider.dart';
import '../utils/app_theme.dart';
import '../utils/menu_data.dart';
import '../widgets/common_widgets.dart';
import 'cart_screen.dart';

class MenuScreen extends StatefulWidget {
  final MenuCategory initialCategory;
  const MenuScreen({super.key, this.initialCategory = MenuCategory.vegPizza});
  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late MenuCategory _selected;
  final _scroll = ScrollController();

  static const _cats = [
    (MenuCategory.vegPizza,  '🍕', 'Veg Pizza'),
    (MenuCategory.special,   '👑', 'Special'),
    (MenuCategory.burger,    '🍔', 'Burgers'),
    (MenuCategory.pasta,     '🍝', 'Pasta'),
    (MenuCategory.shakes,    '🧋', 'Shakes'),
    (MenuCategory.wraps,     '🌯', 'Wraps'),
    (MenuCategory.fries,     '🍟', 'Fries'),
    (MenuCategory.sandwich,  '🥪', 'Sandwich'),
    (MenuCategory.tacos,     '🌮', 'Tacos'),
    (MenuCategory.snacks,    '🥔', 'Snacks'),
    (MenuCategory.garlic,    '🧄', 'Garlic'),
    (MenuCategory.meals,     '🎁', 'Meals'),
  ];

  @override
  void initState() { super.initState(); _selected = widget.initialCategory; }
  @override
  void dispose() { _scroll.dispose(); super.dispose(); }

  List<MenuItem> get _items => MenuData.allItems.where((i) => i.category == _selected).toList();
  String get _title { final c = _cats.where((c) => c.$1 == _selected).firstOrNull; return c != null ? '${c.$2} ${c.$3}' : 'Menu'; }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
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
        Row(children: [
          // Left category rail
          Container(
            width: 76, color: const Color(0xFFF5F5F5),
            child: ListView.builder(
              itemCount: _cats.length,
              itemBuilder: (ctx, i) {
                final cat = _cats[i];
                final sel = cat.$1 == _selected;
                return GestureDetector(
                  onTap: () {
                    setState(() => _selected = cat.$1);
                    _scroll.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                    decoration: BoxDecoration(
                      color: sel ? Colors.white : Colors.transparent,
                      border: Border(left: BorderSide(color: sel ? AppTheme.primary : Colors.transparent, width: 3)),
                    ),
                    child: Column(children: [
                      Text(cat.$2, style: const TextStyle(fontSize: 22)),
                      const SizedBox(height: 3),
                      Text(cat.$3, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 9.5, fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                              color: sel ? AppTheme.primary : AppTheme.textGrey)),
                    ]),
                  ),
                );
              },
            ),
          ),
          // Right items
          Expanded(child: _items.isEmpty
              ? const Center(child: Text('No items', style: TextStyle(color: AppTheme.textGrey)))
              : ListView.builder(
                  controller: _scroll,
                  padding: const EdgeInsets.only(top: 8, bottom: 100),
                  itemCount: _items.length,
                  itemBuilder: (ctx, i) => MenuItemCard(item: _items[i]),
                )),
        ]),
        FloatingCartBar(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()))),
      ]),
    );
  }
}
