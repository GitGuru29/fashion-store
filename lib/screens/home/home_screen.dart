import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/mock_data.dart';
import '../../models/product.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../product_detail/product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentBanner = 0;
  String _selectedCategory = 'All';
  final PageController _bannerController = PageController(viewportFraction: 0.88);

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  void _openDetail(BuildContext context, Product product) {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)));
  }

  @override
  Widget build(BuildContext context) {
    final categories = MockData.categories;
    final banners = MockData.banners;
    final featured = MockData.featuredProducts;
    final newArrivals = MockData.newArrivals;
    final cartCount = context.watch<CartProvider>().itemCount;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // AppBar
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: AppColors.background,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.menu_rounded, color: AppColors.textPrimary, size: 20),
              ),
            ),
            title: Text('BELLDI', style: GoogleFonts.playfairDisplay(
              fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary, letterSpacing: 3)),
            actions: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10)),
                  child: const Padding(padding: EdgeInsets.all(6),
                    child: Icon(Icons.notifications_outlined, color: AppColors.textPrimary, size: 20)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Stack(clipBehavior: Clip.none, children: [
                  Container(
                    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10)),
                    child: const Padding(padding: EdgeInsets.all(6),
                      child: Icon(Icons.shopping_bag_outlined, color: AppColors.textPrimary, size: 20)),
                  ),
                  if (cartCount > 0)
                    Positioned(top: -4, right: -4,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                        child: Text('$cartCount', style: const TextStyle(fontSize: 9, color: Colors.white)),
                      )),
                ]),
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Good Morning! 👋', style: AppTextStyles.bodyMedium),
                    const SizedBox(height: 4),
                    Text('Find your perfect look', style: AppTextStyles.displaySmall),
                  ]),
                ),

                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Row(children: [
                      const SizedBox(width: 14),
                      const Icon(Icons.search_rounded, color: AppColors.textHint, size: 20),
                      const SizedBox(width: 10),
                      Text('Search for fashion...', style: GoogleFonts.inter(color: AppColors.textHint, fontSize: 14)),
                      const Spacer(),
                      Container(
                        margin: const EdgeInsets.all(6),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.tune_rounded, color: Colors.white, size: 16),
                      ),
                    ]),
                  ),
                ),
                const SizedBox(height: 24),

                // Banner Carousel (native PageView)
                SizedBox(
                  height: 200,
                  child: PageView.builder(
                    controller: _bannerController,
                    itemCount: banners.length,
                    onPageChanged: (i) => setState(() => _currentBanner = i),
                    itemBuilder: (context, i) {
                      final banner = banners[i];
                      return AnimatedScale(
                        scale: _currentBanner == i ? 1.0 : 0.93,
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 16, offset: const Offset(0, 8))],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Stack(fit: StackFit.expand, children: [
                              Image.network(banner['image']!, fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(color: AppColors.surface,
                                  child: const Icon(Icons.image, color: AppColors.textHint, size: 48))),
                              Container(decoration: const BoxDecoration(gradient: AppColors.bannerGradient)),
                              Positioned(left: 20, right: 20, bottom: 20,
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(6)),
                                    child: Text(banner['tag']!, style: GoogleFonts.inter(
                                      fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 1.5)),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(banner['title']!, style: AppTextStyles.headlineLarge),
                                  Text(banner['subtitle']!, style: AppTextStyles.bodySmall),
                                ]),
                              ),
                            ]),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Banner dots
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(banners.length, (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: _currentBanner == i ? 20 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: _currentBanner == i ? AppColors.accent : AppColors.textHint,
                      borderRadius: BorderRadius.circular(3)),
                  )),
                ),
                const SizedBox(height: 28),

                // Categories
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('Categories', style: AppTextStyles.headlineMedium),
                    Text('See all', style: GoogleFonts.inter(fontSize: 13, color: AppColors.accent, fontWeight: FontWeight.w500)),
                  ]),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, i) {
                      final cat = categories[i];
                      final selected = _selectedCategory == cat.name;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedCategory = cat.name),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          child: Column(children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 62, height: 62,
                              decoration: BoxDecoration(
                                gradient: selected ? AppColors.accentGradient : null,
                                color: selected ? null : AppColors.surface,
                                shape: BoxShape.circle,
                                boxShadow: selected ? [BoxShadow(
                                  color: AppColors.accent.withValues(alpha: 0.4),
                                  blurRadius: 12, spreadRadius: 2)] : null,
                              ),
                              child: ClipOval(
                                child: Image.network(cat.imageUrl, fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Center(
                                    child: Text(cat.emoji, style: const TextStyle(fontSize: 26)))),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(cat.name, style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                              color: selected ? AppColors.accent : AppColors.textSecondary)),
                          ]),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 28),

                // Featured
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('Featured', style: AppTextStyles.headlineMedium),
                    Text('See all', style: GoogleFonts.inter(fontSize: 13, color: AppColors.accent, fontWeight: FontWeight.w500)),
                  ]),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 260,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: featured.length,
                    itemBuilder: (context, i) => _ProductCardH(
                      product: featured[i],
                      onTap: () => _openDetail(context, featured[i])),
                  ),
                ),
                const SizedBox(height: 28),

                // New Arrivals
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('New Arrivals', style: AppTextStyles.headlineMedium),
                    Text('See all', style: GoogleFonts.inter(fontSize: 13, color: AppColors.accent, fontWeight: FontWeight.w500)),
                  ]),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: newArrivals.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.72),
                  itemBuilder: (context, i) => _ProductCardGrid(
                    product: newArrivals[i],
                    onTap: () => _openDetail(context, newArrivals[i])),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Horizontal Product Card ───────────────────────────────────────────────

class _ProductCardH extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  const _ProductCardH({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 165,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(18)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: Stack(children: [
              SizedBox(
                height: 170, width: double.infinity,
                child: Image.network(product.images.first, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(color: AppColors.surface,
                    child: const Icon(Icons.checkroom, color: AppColors.textHint, size: 48))),
              ),
              if (product.isNew)
                Positioned(top: 10, left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(6)),
                    child: Text('NEW', style: GoogleFonts.inter(
                      fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 1)))),
              if (product.isOnSale)
                Positioned(top: 10, right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(6)),
                    child: Text('-${product.discountPercent}%',
                      style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white)))),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(product.name,
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Row(children: [
                const Icon(Icons.star_rounded, color: AppColors.accent, size: 13),
                const SizedBox(width: 2),
                Text(product.rating.toString(),
                  style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary)),
              ]),
              const SizedBox(height: 4),
              Row(children: [
                Text('\$${product.price.toStringAsFixed(2)}', style: AppTextStyles.priceSmall),
                if (product.isOnSale) ...[
                  const SizedBox(width: 6),
                  Text('\$${product.originalPrice!.toStringAsFixed(2)}', style: AppTextStyles.priceStrikethrough),
                ],
              ]),
            ]),
          ),
        ]),
      ),
    );
  }
}

// ─── Grid Product Card ──────────────────────────────────────────────────────

class _ProductCardGrid extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  const _ProductCardGrid({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final wishlist = context.watch<WishlistProvider>();
    final isWishlisted = wishlist.isWishlisted(product.id);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(18)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              child: Stack(fit: StackFit.expand, children: [
                Image.network(product.images.first, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(color: AppColors.surface,
                    child: const Icon(Icons.checkroom, color: AppColors.textHint, size: 48))),
                Positioned(top: 8, right: 8,
                  child: GestureDetector(
                    onTap: () => wishlist.toggle(product),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                      child: Icon(
                        isWishlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: isWishlisted ? AppColors.accent : Colors.white,
                        size: 16)))),
                if (product.isNew)
                  Positioned(top: 8, left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(4)),
                      child: Text('NEW', style: GoogleFonts.inter(
                        fontSize: 8, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 1)))),
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(product.name,
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('\$${product.price.toStringAsFixed(2)}', style: AppTextStyles.priceSmall),
                Row(children: [
                  const Icon(Icons.star_rounded, color: AppColors.accent, size: 12),
                  Text(product.rating.toString(),
                    style: GoogleFonts.inter(fontSize: 10, color: AppColors.textSecondary)),
                ]),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }
}
