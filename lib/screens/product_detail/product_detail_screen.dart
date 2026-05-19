import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/product.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wishlist_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});
  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _currentImage = 0;
  String? _selectedSize;
  String? _selectedColor;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _selectedSize = widget.product.sizes.isNotEmpty ? widget.product.sizes[1 < widget.product.sizes.length ? 1 : 0] : null;
    _selectedColor = widget.product.colors.isNotEmpty ? widget.product.colors.first : null;
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final wishlist = context.watch<WishlistProvider>();
    final cart = context.read<CartProvider>();
    final isWishlisted = wishlist.isWishlisted(product.id);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Image Gallery
          SliverAppBar(
            expandedHeight: 380,
            pinned: true,
            backgroundColor: AppColors.backgroundDark,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.black45, shape: BoxShape.circle),
                child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () => wishlist.toggle(product),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.black45, shape: BoxShape.circle),
                  child: Icon(
                    isWishlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: isWishlisted ? AppColors.accent : Colors.white,
                    size: 20),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.black45, shape: BoxShape.circle),
                child: const Icon(Icons.share_outlined, color: Colors.white, size: 20),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  PageView.builder(
                    itemCount: product.images.length,
                    onPageChanged: (i) => setState(() => _currentImage = i),
                    itemBuilder: (_, i) => Image.network(product.images[i], fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(color: AppColors.surface,
                        child: const Icon(Icons.checkroom, color: AppColors.textHint, size: 80))),
                  ),
                  // Image dots
                  if (product.images.length > 1)
                    Positioned(
                      bottom: 16, left: 0, right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(product.images.length, (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: _currentImage == i ? 20 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: _currentImage == i ? AppColors.accent : Colors.white54,
                            borderRadius: BorderRadius.circular(3)),
                        )),
                      ),
                    ),
                  // Discount badge
                  if (product.isOnSale)
                    Positioned(
                      top: 80, left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(8)),
                        child: Text('-${product.discountPercent}% OFF',
                          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Product Info
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand + Name
                    Text(product.brand, style: GoogleFonts.inter(
                      fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.accent, letterSpacing: 2)),
                    const SizedBox(height: 8),
                    Text(product.name, style: AppTextStyles.displaySmall),
                    const SizedBox(height: 12),

                    // Rating + Reviews + Stock
                    Row(children: [
                      ...List.generate(5, (i) => Icon(
                        i < product.rating.floor() ? Icons.star_rounded : Icons.star_outline_rounded,
                        color: AppColors.accent, size: 18)),
                      const SizedBox(width: 8),
                      Text('${product.rating}', style: GoogleFonts.inter(
                        fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      Text(' (${product.reviewCount} reviews)', style: AppTextStyles.bodySmall),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: product.stock > 10 ? AppColors.success.withOpacity(0.15) : AppColors.warning.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          product.stock > 10 ? 'In Stock' : '${product.stock} left',
                          style: GoogleFonts.inter(
                            fontSize: 11, fontWeight: FontWeight.w600,
                            color: product.stock > 10 ? AppColors.success : AppColors.warning)),
                      ),
                    ]),
                    const SizedBox(height: 20),

                    // Price
                    Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Text('\$${product.price.toStringAsFixed(2)}', style: AppTextStyles.price),
                      if (product.isOnSale) ...[
                        const SizedBox(width: 10),
                        Text('\$${product.originalPrice!.toStringAsFixed(2)}', style: AppTextStyles.priceStrikethrough),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                          child: Text('Save \$${(product.originalPrice! - product.price).toStringAsFixed(2)}',
                            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.accent))),
                      ],
                    ]),
                    const SizedBox(height: 24),

                    // Colors
                    Text('Color', style: AppTextStyles.headlineSmall),
                    const SizedBox(height: 12),
                    Row(children: product.colors.map((c) {
                      Color color;
                      try { color = Color(int.parse(c.replaceFirst('#', '0xFF'))); }
                      catch (_) { color = AppColors.accent; }
                      final selected = _selectedColor == c;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedColor = c),
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          width: 34, height: 34,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selected ? AppColors.accent : Colors.transparent,
                              width: 2),
                            boxShadow: selected ? [BoxShadow(color: AppColors.accent.withOpacity(0.5), blurRadius: 8, spreadRadius: 1)] : null,
                          ),
                          child: selected ? const Icon(Icons.check_rounded, color: Colors.white, size: 16) : null,
                        ),
                      );
                    }).toList()),
                    const SizedBox(height: 24),

                    // Sizes
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('Size', style: AppTextStyles.headlineSmall),
                      Text('Size Guide', style: GoogleFonts.inter(fontSize: 12, color: AppColors.accent, fontWeight: FontWeight.w500)),
                    ]),
                    const SizedBox(height: 12),
                    Wrap(spacing: 10, runSpacing: 10,
                      children: product.sizes.map((size) {
                        final selected = _selectedSize == size;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedSize = size),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: 50, height: 44,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: selected ? AppColors.accentGradient : null,
                              color: selected ? null : AppColors.surface,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: selected ? AppColors.accent : AppColors.divider),
                            ),
                            child: Text(size, style: GoogleFonts.inter(
                              fontSize: 13, fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                              color: selected ? Colors.white : AppColors.textSecondary)),
                          ),
                        );
                      }).toList()),
                    const SizedBox(height: 24),

                    // Description
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('Description', style: AppTextStyles.headlineSmall),
                      GestureDetector(
                        onTap: () => setState(() => _isExpanded = !_isExpanded),
                        child: Icon(_isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                          color: AppColors.accent)),
                    ]),
                    const SizedBox(height: 8),
                    AnimatedCrossFade(
                      firstChild: Text(product.description, style: AppTextStyles.bodyMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                      secondChild: Text(product.description, style: AppTextStyles.bodyMedium),
                      crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 300),
                    ),
                    const SizedBox(height: 32),

                    // Buttons
                    Row(children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.shopping_cart_outlined, size: 18),
                          label: const Text('Add to Cart'),
                          onPressed: () {
                            if (_selectedSize != null && _selectedColor != null) {
                              cart.addToCart(product, _selectedSize!, _selectedColor!);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Added to cart!', style: GoogleFonts.inter(color: Colors.white)),
                                  backgroundColor: AppColors.surface,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  duration: const Duration(seconds: 2),
                                ));
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.flash_on_rounded, size: 18),
                          label: const Text('Buy Now'),
                          onPressed: () {
                            if (_selectedSize != null && _selectedColor != null) {
                              cart.addToCart(product, _selectedSize!, _selectedColor!);
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ),
                    ]),
                    const SizedBox(height: 24),

                    // Features
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                        _Feature(icon: Icons.local_shipping_outlined, label: 'Free\nShipping'),
                        _Feature(icon: Icons.replay_outlined, label: 'Easy\nReturns'),
                        _Feature(icon: Icons.verified_outlined, label: '100%\nGenuine'),
                        _Feature(icon: Icons.support_agent_outlined, label: '24/7\nSupport'),
                      ]),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Feature extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Feature({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, color: AppColors.accent, size: 22),
      const SizedBox(height: 6),
      Text(label, style: GoogleFonts.inter(fontSize: 10, color: AppColors.textSecondary, height: 1.4), textAlign: TextAlign.center),
    ]);
  }
}
