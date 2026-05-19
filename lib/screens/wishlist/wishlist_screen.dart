import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/wishlist_provider.dart';
import '../../providers/cart_provider.dart';
import '../product_detail/product_detail_screen.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlist = context.watch<WishlistProvider>();
    final cart = context.read<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Wishlist', style: AppTextStyles.headlineLarge),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          if (wishlist.items.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
                child: Text('${wishlist.count} items', style: GoogleFonts.inter(
                  fontSize: 12, color: AppColors.accent, fontWeight: FontWeight.w600)),
              )),
            ),
        ],
      ),
      body: wishlist.items.isEmpty
          ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                width: 100, height: 100,
                decoration: BoxDecoration(color: AppColors.surface, shape: BoxShape.circle),
                child: const Icon(Icons.favorite_border_rounded, color: AppColors.textHint, size: 48),
              ),
              const SizedBox(height: 24),
              Text('Your wishlist is empty', style: AppTextStyles.headlineMedium),
              const SizedBox(height: 8),
              Text('Save items you love', style: AppTextStyles.bodyMedium),
              const SizedBox(height: 24),
            ]))
          : GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              itemCount: wishlist.items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.62),
              itemBuilder: (context, i) {
                final product = wishlist.items[i];
                return GestureDetector(
                  onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product))),
                  child: Container(
                    decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(18)),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Expanded(
                        flex: 3,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                          child: Stack(fit: StackFit.expand, children: [
                            Image.network(product.images.first, fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(color: AppColors.surface,
                                child: const Icon(Icons.checkroom, color: AppColors.textHint, size: 48))),
                            Positioned(top: 8, right: 8,
                              child: GestureDetector(
                                onTap: () => wishlist.remove(product.id),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                                  child: const Icon(Icons.favorite_rounded, color: AppColors.accent, size: 16)))),
                          ]),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(product.name,
                              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                              maxLines: 2, overflow: TextOverflow.ellipsis),
                            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('\$${product.price.toStringAsFixed(2)}', style: AppTextStyles.priceSmall),
                              const SizedBox(height: 6),
                              SizedBox(
                                height: 30,
                                child: ElevatedButton(
                                  onPressed: () {
                                    cart.addToCart(product, product.sizes.first, product.colors.first);
                                    wishlist.remove(product.id);
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text('Moved to cart!', style: GoogleFonts.inter(color: Colors.white)),
                                      backgroundColor: AppColors.surface,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      duration: const Duration(seconds: 2),
                                    ));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size.zero,
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    textStyle: const TextStyle(fontSize: 11),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: const Text('Add to Cart'),
                                ),
                              ),
                            ]),
                          ]),
                        ),
                      ),
                    ]),
                  ),
                );
              },
            ),
    );
  }
}
