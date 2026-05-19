import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/mock_data.dart';
import '../../models/product.dart';
import '../../providers/wishlist_provider.dart';
import '../product_detail/product_detail_screen.dart';

class ProductListingScreen extends StatefulWidget {
  const ProductListingScreen({super.key});
  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  String _selectedCategory = 'All';
  String _sortBy = 'Popular';
  final List<String> _categories = ['All', 'Women', 'Men', 'Kids', 'Accessories', 'Bags', 'Sale'];
  final List<String> _sortOptions = ['Popular', 'Newest', 'Price: Low', 'Price: High', 'Rating'];

  List<Product> get _filteredProducts {
    List<Product> list = List.from(MockData.products);
    if (_selectedCategory != 'All') {
      list = list.where((p) => p.category == _selectedCategory.toLowerCase()).toList();
    }
    switch (_sortBy) {
      case 'Newest':
        list.sort((a, b) => (b.isNew ? 1 : 0).compareTo(a.isNew ? 1 : 0));
      case 'Price: Low':
        list.sort((a, b) => a.price.compareTo(b.price));
      case 'Price: High':
        list.sort((a, b) => b.price.compareTo(a.price));
      case 'Rating':
        list.sort((a, b) => b.rating.compareTo(a.rating));
      default:
        list.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final products = _filteredProducts;
    final wishlist = context.watch<WishlistProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Shop', style: AppTextStyles.headlineLarge),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.search_rounded, color: AppColors.textPrimary), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.tune_rounded, color: AppColors.accent),
            onPressed: () => _showFilterSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Category chips
          SizedBox(
            height: 44,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, i) {
                final cat = _categories[i];
                final selected = _selectedCategory == cat;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: selected ? AppColors.accentGradient : null,
                      color: selected ? null : AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: selected ? AppColors.accent : AppColors.divider),
                    ),
                    child: Text(cat, style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                      color: selected ? Colors.white : AppColors.textSecondary,
                    )),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${products.length} items', style: AppTextStyles.bodyMedium),
                GestureDetector(
                  onTap: () => _showSortSheet(context),
                  child: Row(children: [
                    Text(_sortBy, style: GoogleFonts.inter(fontSize: 13, color: AppColors.accent, fontWeight: FontWeight.w500)),
                    const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.accent, size: 18),
                  ]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          Expanded(
            child: products.isEmpty
                ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.inventory_2_outlined, color: AppColors.textHint, size: 64),
                    const SizedBox(height: 16),
                    Text('No products found', style: AppTextStyles.headlineSmall),
                    Text('Try a different category', style: AppTextStyles.bodyMedium),
                  ]))
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    itemCount: products.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.65),
                    itemBuilder: (context, i) {
                      final p = products[i];
                      final isWishlisted = wishlist.isWishlisted(p.id);
                      return GestureDetector(
                        onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => ProductDetailScreen(product: p))),
                        child: Container(
                          decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(18)),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Expanded(flex: 3,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                                child: Stack(fit: StackFit.expand, children: [
                                  Image.network(p.images.first, fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(color: AppColors.surface,
                                      child: const Icon(Icons.checkroom, color: AppColors.textHint, size: 48))),
                                  Positioned(top: 8, right: 8,
                                    child: GestureDetector(
                                      onTap: () => wishlist.toggle(p),
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(color: Colors.black45, shape: BoxShape.circle),
                                        child: Icon(isWishlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                          color: isWishlisted ? AppColors.accent : Colors.white, size: 16)))),
                                  if (p.isOnSale)
                                    Positioned(top: 8, left: 8,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(4)),
                                        child: Text('-${p.discountPercent}%',
                                          style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white)))),
                                ]),
                              )),
                            Expanded(flex: 2,
                              child: Padding(padding: const EdgeInsets.all(10),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Text(p.name,
                                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                                    maxLines: 2, overflow: TextOverflow.ellipsis),
                                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Row(children: [
                                      const Icon(Icons.star_rounded, color: AppColors.accent, size: 12),
                                      const SizedBox(width: 2),
                                      Text(p.rating.toString(),
                                        style: GoogleFonts.inter(fontSize: 10, color: AppColors.textSecondary)),
                                      Text(' (${p.reviewCount})',
                                        style: GoogleFonts.inter(fontSize: 10, color: AppColors.textHint)),
                                    ]),
                                    const SizedBox(height: 4),
                                    Row(children: [
                                      Text('\$${p.price.toStringAsFixed(2)}', style: AppTextStyles.priceSmall),
                                      if (p.isOnSale) ...[
                                        const SizedBox(width: 4),
                                        Text('\$${p.originalPrice!.toStringAsFixed(2)}', style: AppTextStyles.priceStrikethrough),
                                      ],
                                    ]),
                                  ]),
                                ]),
                              )),
                          ]),
                        ),
                      );
                    }),
          ),
        ],
      ),
    );
  }

  void _showSortSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Sort By', style: AppTextStyles.headlineMedium),
          const SizedBox(height: 16),
          ..._sortOptions.map((opt) => ListTile(
            title: Text(opt, style: GoogleFonts.inter(color: AppColors.textPrimary)),
            trailing: _sortBy == opt ? const Icon(Icons.check_rounded, color: AppColors.accent) : null,
            onTap: () { setState(() => _sortBy = opt); Navigator.pop(context); },
          )),
        ]),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Filters', style: AppTextStyles.headlineMedium),
            TextButton(onPressed: () => Navigator.pop(context),
              child: Text('Apply', style: GoogleFonts.inter(color: AppColors.accent))),
          ]),
          const SizedBox(height: 16),
          Text('Sizes', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 12),
          Wrap(spacing: 8, runSpacing: 8,
            children: ['XS', 'S', 'M', 'L', 'XL', 'XXL'].map((s) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.divider)),
              child: Text(s, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textPrimary)),
            )).toList()),
          const SizedBox(height: 24),
        ]),
      ),
    );
  }
}
