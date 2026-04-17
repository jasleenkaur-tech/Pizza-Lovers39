// lib/screens/combos_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_provider.dart';
import '../utils/app_theme.dart';
import '../utils/menu_data.dart';
import '../widgets/common_widgets.dart';
import 'cart_screen.dart';

class CombosScreen extends StatelessWidget {
  const CombosScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎁 Meal Combos'),
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
        ListView(padding: const EdgeInsets.only(top: 8, bottom: 100), children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3CD),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFFFD700), width: 1.5),
            ),
            child: const Row(children: [
              Text('💡', style: TextStyle(fontSize: 24)),
              SizedBox(width: 10),
              Expanded(child: Text('Save big with our Meal Combos! Complete meals at unbeatable prices.',
                  style: TextStyle(color: Color(0xFF856404), fontWeight: FontWeight.w600, fontSize: 13))),
            ]),
          ),
          ...MenuData.meals.map((item) => MenuItemCard(item: item)),
        ]),
        FloatingCartBar(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()))),
      ]),
    );
  }
}
