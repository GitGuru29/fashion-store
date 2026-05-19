import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/mock_data.dart';
import 'widgets/product_grid_card.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  String _selectedCategory = 'Shoes';
  bool _isGridView = true;

  final List<Map<String, dynamic>> _categories = [
    {'name': 'TShirt', 'icon': Icons.checkroom},
    {'name': 'Shoes', 'icon': Icons.snowshoeing},
    {'name': 'Bag', 'icon': Icons.shopping_bag},
    {'name': 'Dress', 'icon': Icons.woman},
  ];

  @override
  Widget build(BuildContext context) {
    // Get all products to display, just using the mock data for visual layout
    final products = MockData.products;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Products',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  // Search Bar
                  Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 20),
                        Expanded(
                          child: Text(
                            'Search man fashion..',
                            style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 15),
                          ),
                        ),
                        Icon(Icons.search, color: Colors.grey.shade400, size: 24),
                        const SizedBox(width: 20),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Horizontal Categories
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final cat = _categories[index];
                        final isSelected = _selectedCategory == cat['name'];
                        
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategory = cat['name'] as String;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Column(
                              children: [
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8EBFF), // Light blue background
                                    borderRadius: BorderRadius.circular(18),
                                    border: isSelected 
                                        ? Border.all(color: const Color(0xFF3342B3), width: 2) 
                                        : Border.all(color: Colors.transparent, width: 2),
                                  ),
                                  child: Icon(
                                    cat['icon'] as IconData,
                                    color: const Color(0xFF3342B3),
                                    size: 32,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  cat['name'] as String,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                    color: isSelected ? Colors.black : Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '567 Products',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Based your filter',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                      
                      // Toggle Buttons
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => setState(() => _isGridView = false),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: !_isGridView ? const Color(0xFF3342B3).withOpacity(0.3) : Colors.grey.shade200,
                                ),
                              ),
                              child: Icon(
                                Icons.format_list_bulleted_rounded, 
                                size: 20,
                                color: !_isGridView ? const Color(0xFF3342B3) : Colors.grey.shade400,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () => setState(() => _isGridView = true),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _isGridView ? const Color(0xFF3342B3).withOpacity(0.3) : Colors.grey.shade200,
                                ),
                              ),
                              child: Icon(
                                Icons.grid_view_rounded, 
                                size: 20,
                                color: _isGridView ? const Color(0xFF3342B3) : Colors.grey.shade400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          
          // Products Grid
          if (_isGridView)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65, // Adjust for taller cards
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return ProductGridCard(product: products[index]);
                  },
                  childCount: products.length,
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    // Reusing the grid card for list view as well for simplicity, 
                    // just forcing it to span full width and modifying its height.
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: SizedBox(
                        height: 280, 
                        child: ProductGridCard(product: products[index]),
                      ),
                    );
                  },
                  childCount: products.length,
                ),
              ),
            ),
            
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}
