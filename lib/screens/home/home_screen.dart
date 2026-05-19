import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/mock_data.dart';
import '../../models/product.dart';
import '../product_detail/product_detail_screen.dart';
import '../products/products_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _openDetail(BuildContext context, Product product) {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)));
  }

  void _openProducts(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => const ProductsScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final featured = MockData.featuredProducts;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                // 1. Header
                _buildHeader(),
                const SizedBox(height: 24),
                
                // 2. Search
                _buildSearch(),
                const SizedBox(height: 24),
                
                // 3. Banner
                _buildBanner(),
                
                // Banner Dots
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(width: 16, height: 4, decoration: BoxDecoration(color: const Color(0xFF3342B3), borderRadius: BorderRadius.circular(2))),
                    const SizedBox(width: 4),
                    Container(width: 16, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
                    const SizedBox(width: 4),
                    Container(width: 16, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
                    const SizedBox(width: 4),
                    Container(width: 16, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
                  ],
                ),
                const SizedBox(height: 24),
                
                // 4. Categories Grid
                _buildCategoryGrid(),
                const SizedBox(height: 32),
                
                // 5. Featured Products Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Featured Products',
                      style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black),
                    ),
                    GestureDetector(
                      onTap: () => _openProducts(context),
                      child: Text(
                        'More',
                        style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF3342B3)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // 6. Featured Products List
                _buildFeaturedList(featured),
                const SizedBox(height: 100), // Bottom spacing for nav bar
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hello', style: GoogleFonts.inter(fontSize: 15, color: Colors.grey.shade600)),
            Text('Thisaranga', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.black)),
          ],
        ),
        Row(
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Icon(Icons.favorite_rounded, color: Colors.grey.shade400, size: 22),
            ),
            const SizedBox(width: 12),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Icon(Icons.notifications_none_rounded, color: Colors.grey.shade600, size: 24),
                ),
                Positioned(
                  top: -6, right: -6,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Color(0xFF3342B3), 
                      shape: BoxShape.circle,
                    ),
                    child: const Text('4', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearch() {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const SizedBox(width: 20),
          Expanded(
            child: Text('Search man fashion..', style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 15)),
          ),
          Icon(Icons.search, color: Colors.grey.shade400, size: 24),
          const SizedBox(width: 20),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFFD3C5B5),
      ),
      child: Stack(
        children: [
          // Silhouette / Model image
          Positioned(
            left: 0, bottom: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20)),
              child: Image.network(
                'https://images.unsplash.com/photo-1593030761757-71fae46af504?auto=format&fit=crop&q=80&w=300', // Man in suit
                width: 160,
                height: 160,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
          // Content
          Positioned(
            right: 24, top: 32,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Row(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text('50%', style: GoogleFonts.inter(fontSize: 34, fontWeight: FontWeight.w800, color: Colors.white)),
                     Padding(
                       padding: const EdgeInsets.only(top: 6.0, left: 4),
                       child: Text('OFF', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
                     ),
                   ]
                 ),
                 const SizedBox(height: 4),
                 Text('Get Summer Sale Now', style: GoogleFonts.inter(fontSize: 13, color: Colors.white.withOpacity(0.9))),
                 const SizedBox(height: 16),
                 Container(
                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                   decoration: BoxDecoration(color: const Color(0xFFECA361), borderRadius: BorderRadius.circular(6)),
                   child: Text('SHOP NOW', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                 ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildCategoryCard(icon: Icons.checkroom, title: 'Man Fashion', subtitle: 'TShirt', bottomText: '312 Collections')),
            const SizedBox(width: 16),
            Expanded(child: _buildCategoryCard(icon: Icons.snowshoeing, title: 'Formal Shoes', subtitle: 'Shoes', bottomText: '231 Collections')),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildCategoryCard(icon: Icons.watch, title: 'Original Watch', subtitle: 'Hand Watch', bottomText: '65 Collections')),
            const SizedBox(width: 16),
            Expanded(child: _buildCategoryCard(icon: Icons.play_arrow_rounded, title: '87+ Collection', subtitle: 'Check out more', bottomText: '', isPlay: true)),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryCard({
    required IconData icon, 
    required String title, 
    required String subtitle, 
    required String bottomText,
    bool isPlay = false,
  }) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        color: const Color(0xFF3342B3),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          // Background icon
          Positioned(
            right: -10, bottom: -10,
            child: Icon(icon, size: 80, color: Colors.white.withOpacity(0.06)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: isPlay ? EdgeInsets.zero : const EdgeInsets.only(bottom: 4),
                child: isPlay 
                  ? Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white24)),
                      child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 20),
                    )
                  : Icon(icon, color: Colors.white, size: 28),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isPlay) Text(subtitle, style: GoogleFonts.inter(color: Colors.white70, fontSize: 11)),
                  if (isPlay) Text(subtitle, style: GoogleFonts.inter(color: Colors.white70, fontSize: 11)),
                  const SizedBox(height: 2),
                  Text(title, style: GoogleFonts.inter(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                  if (bottomText.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(bottomText, style: GoogleFonts.inter(color: Colors.white70, fontSize: 11)),
                  ]
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedList(List<Product> products) {
    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        clipBehavior: Clip.none,
        itemBuilder: (context, i) {
          return _buildProductCard(context, products[i]);
        },
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () => _openDetail(context, product),
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04), 
              blurRadius: 15, 
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.network(
                product.images.first, 
                height: 160, 
                width: double.infinity, 
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade100, height: 160, child: const Icon(Icons.image, color: Colors.grey)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name, 
                    style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black), 
                    maxLines: 2, 
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'RS.${product.price.toStringAsFixed(2)}', 
                        style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.black),
                      ),
                      Row(
                        children: [
                          Text('45 ', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF3342B3))),
                          Text('left', style: GoogleFonts.inter(fontSize: 13, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.star, color: Color(0xFFF8B100), size: 14),
                          Icon(Icons.star, color: Color(0xFFF8B100), size: 14),
                          Icon(Icons.star, color: Color(0xFFF8B100), size: 14),
                          Icon(Icons.star, color: Color(0xFFF8B100), size: 14),
                          Icon(Icons.star_half, color: Color(0xFFF8B100), size: 14),
                        ],
                      ),
                      const SizedBox(width: 4),
                      Text('(245 Reviews)', style: GoogleFonts.inter(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
