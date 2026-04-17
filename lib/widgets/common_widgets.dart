// lib/widgets/common_widgets.dart

import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../models/cart_provider.dart';
import '../utils/app_theme.dart';
import 'package:provider/provider.dart';

// ── Veg Indicator ─────────────────────────────────────────────
class VegIndicator extends StatelessWidget {
  final bool isVeg;
  const VegIndicator({super.key, this.isVeg = true});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16, height: 16,
      decoration: BoxDecoration(
        border: Border.all(color: isVeg ? AppTheme.vegGreen : Colors.red, width: 1.5),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Center(child: Container(
        width: 8, height: 8,
        decoration: BoxDecoration(shape: BoxShape.circle, color: isVeg ? AppTheme.vegGreen : Colors.red),
      )),
    );
  }
}

// ── Sub-Category Badge ────────────────────────────────────────
class SubCategoryBadge extends StatelessWidget {
  final String? label;
  const SubCategoryBadge({super.key, this.label});
  Color get _color {
    switch (label?.toLowerCase()) {
      case 'platinum':      return AppTheme.platinum;
      case 'gold':          return AppTheme.gold;
      case 'silver':        return AppTheme.silver;
      case 'ultimate':      return Colors.deepPurple;
      case 'lover special': return Colors.pink;
      default:              return AppTheme.primary;
    }
  }
  @override
  Widget build(BuildContext context) {
    if (label == null) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withOpacity(0.35)),
      ),
      child: Text(label!, style: TextStyle(fontSize: 9, color: _color, fontWeight: FontWeight.w700)),
    );
  }
}

// ── Bestseller Tag ────────────────────────────────────────────
class BestsellerTag extends StatelessWidget {
  const BestsellerTag({super.key});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(color: Colors.green.shade700, borderRadius: BorderRadius.circular(4)),
    child: const Text('⭐ Best', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
  );
}

// ── Quantity Control ──────────────────────────────────────────
class QuantityControl extends StatelessWidget {
  final MenuItem item;
  final String size;
  final bool compact;
  const QuantityControl({super.key, required this.item, this.size = 'regular', this.compact = false});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final qty  = cart.getItemQuantity(item.id, size: size);
    if (qty == 0) {
      return SizedBox(
        height: compact ? 30 : 34,
        child: ElevatedButton(
          onPressed: () => cart.addItem(item, size: size),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text('ADD', style: TextStyle(fontSize: compact ? 11 : 12, fontWeight: FontWeight.bold, letterSpacing: 0.8)),
        ),
      );
    }
    return Container(
      height: compact ? 30 : 34,
      decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(8)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        _btn(Icons.remove, () => cart.removeItem(item.id, size: size), compact),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text('$qty', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: compact ? 12 : 14))),
        _btn(Icons.add, () => cart.addItem(item, size: size), compact),
      ]),
    );
  }

  Widget _btn(IconData icon, VoidCallback onTap, bool compact) => InkWell(
    onTap: onTap, borderRadius: BorderRadius.circular(8),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: compact ? 6 : 7, vertical: 6),
      child: Icon(icon, color: Colors.white, size: compact ? 13 : 15),
    ),
  );
}

// ── Size Price Selector ───────────────────────────────────────
class SizePriceSelector extends StatefulWidget {
  final MenuItem item;
  const SizePriceSelector({super.key, required this.item});
  @override
  State<SizePriceSelector> createState() => _SizePriceSelectorState();
}

class _SizePriceSelectorState extends State<SizePriceSelector> {
  String _selected = 'regular';
  static const _labels = {'regular': '7"\nReg', 'medium': '10"\nMed', 'large': '13"\nLrg'};

  @override
  Widget build(BuildContext context) {
    final prices = widget.item.prices!;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: prices.keys.map((size) {
        final sel = _selected == size;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selected = size),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: EdgeInsets.only(right: size != prices.keys.last ? 5 : 0),
              padding: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: sel ? AppTheme.primary : Colors.transparent,
                border: Border.all(color: sel ? AppTheme.primary : AppTheme.textGrey.withOpacity(0.4)),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(_labels[size] ?? size, textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700,
                        color: sel ? Colors.white : AppTheme.textGrey, height: 1.3)),
                const SizedBox(height: 1),
                Text('₹${prices[size]!.toStringAsFixed(0)}',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800,
                        color: sel ? Colors.white : AppTheme.primary)),
              ]),
            ),
          ),
        );
      }).toList()),
      const SizedBox(height: 8),
      Align(alignment: Alignment.centerRight, child: QuantityControl(item: widget.item, size: _selected)),
    ]);
  }
}

// ── Menu Item Card ────────────────────────────────────────────
class MenuItemCard extends StatelessWidget {
  final MenuItem item;
  const MenuItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final hasSizes = item.prices != null && item.prices!.length > 1;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 68, height: 68,
            decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(12)),
            child: Center(child: Text(item.emoji, style: const TextStyle(fontSize: 32))),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                VegIndicator(isVeg: item.isVeg),
                const SizedBox(width: 5),
                if (item.isBestseller) const BestsellerTag(),
                if (item.subCategory != null) ...[
                  const SizedBox(width: 4),
                  Flexible(child: SubCategoryBadge(label: item.subCategory)),
                ],
              ]),
              const SizedBox(height: 4),
              Text(item.name,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppTheme.textDark),
                  maxLines: 2, overflow: TextOverflow.ellipsis),
              if (item.description.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(item.description,
                    style: const TextStyle(color: AppTheme.textGrey, fontSize: 11),
                    maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
              const SizedBox(height: 8),
              if (hasSizes)
                SizePriceSelector(item: item)
              else
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Flexible(child: Text('₹${item.getPrice().toStringAsFixed(0)}',
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppTheme.primary),
                      overflow: TextOverflow.ellipsis)),
                  const SizedBox(width: 8),
                  QuantityControl(item: item),
                ]),
            ]),
          ),
        ]),
      ),
    );
  }
}

// ── Section Header ────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  const SectionHeader({super.key, required this.title, this.subtitle});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.textDark)),
        if (subtitle != null) Text(subtitle!, style: const TextStyle(color: AppTheme.textGrey, fontSize: 13)),
        Container(height: 3, width: 40, color: AppTheme.primary, margin: const EdgeInsets.only(top: 4)),
      ]),
    );
  }
}

// ── Floating Cart Bar ─────────────────────────────────────────
class FloatingCartBar extends StatelessWidget {
  final VoidCallback onTap;
  const FloatingCartBar({super.key, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    if (cart.itemCount == 0) return const SizedBox.shrink();
    return Positioned(
      bottom: 16, left: 16, right: 16,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          decoration: BoxDecoration(
            color: AppTheme.primary,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.4), blurRadius: 16, offset: const Offset(0, 6))],
          ),
          child: Row(children: [
            Flexible(child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.25), borderRadius: BorderRadius.circular(6)),
              child: Text('${cart.itemCount} item${cart.itemCount > 1 ? 's' : ''}',
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis),
            )),
            const Spacer(),
            const Text('View Cart', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
            const SizedBox(width: 6),
            Flexible(child: Text('₹${cart.subtotal.toStringAsFixed(0)}',
                style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
                overflow: TextOverflow.ellipsis)),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 13),
          ]),
        ),
      ),
    );
  }
}
