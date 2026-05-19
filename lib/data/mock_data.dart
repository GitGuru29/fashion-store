import '../models/product.dart';
import '../models/category.dart';
import '../core/constants/app_assets.dart';

class MockData {
  static List<Category> get categories => [
        const Category(
          id: 'women',
          name: 'Women',
          imageUrl: AppAssets.categoryWomen,
          emoji: '👗',
          itemCount: 124,
        ),
        const Category(
          id: 'men',
          name: 'Men',
          imageUrl: AppAssets.categoryMen,
          emoji: '👔',
          itemCount: 86,
        ),
        const Category(
          id: 'kids',
          name: 'Kids',
          imageUrl: AppAssets.categoryKids,
          emoji: '🧒',
          itemCount: 58,
        ),
        const Category(
          id: 'accessories',
          name: 'Accessories',
          imageUrl: AppAssets.categoryAccessories,
          emoji: '👜',
          itemCount: 95,
        ),
        const Category(
          id: 'bags',
          name: 'Bags',
          imageUrl: AppAssets.categoryBags,
          emoji: '👝',
          itemCount: 42,
        ),
        const Category(
          id: 'sale',
          name: 'Sale',
          imageUrl: AppAssets.categorySale,
          emoji: '🏷️',
          itemCount: 210,
        ),
      ];

  static List<Map<String, String>> get banners => [
        {
          'image': AppAssets.bannerWomen,
          'title': 'Summer Collection',
          'subtitle': 'Up to 50% off on women\'s fashion',
          'tag': 'NEW ARRIVAL',
        },
        {
          'image': AppAssets.bannerMen,
          'title': 'Men\'s Edition',
          'subtitle': 'Premium suits & casual wear',
          'tag': 'EXCLUSIVE',
        },
        {
          'image': AppAssets.bannerSummer,
          'title': 'Festival Looks',
          'subtitle': 'Dress to impress this season',
          'tag': 'TRENDING',
        },
        {
          'image': AppAssets.bannerAccessories,
          'title': 'Accessories Drop',
          'subtitle': 'Complete your perfect look',
          'tag': 'SALE',
        },
      ];

  static List<Product> get products => [
        // Women
        Product(
          id: 'p001',
          name: 'Floral Maxi Dress',
          brand: 'BELLDI',
          description:
              'Elegant floral maxi dress perfect for any occasion. Made with premium breathable fabric featuring a delicate floral pattern.',
          price: 89.99,
          originalPrice: 149.99,
          rating: 4.8,
          reviewCount: 234,
          images: [AppAssets.prodDress1, AppAssets.prodDress2, AppAssets.prodTop1],
          category: 'women',
          sizes: ['XS', 'S', 'M', 'L', 'XL'],
          colors: ['#C9956B', '#2A3680', '#FFFFFF'],
          isNew: true,
          isFeatured: true,
          stock: 42,
        ),
        Product(
          id: 'p002',
          name: 'Silk Evening Gown',
          brand: 'BELLDI',
          description:
              'A luxurious silk evening gown that flows with every step. The perfect statement piece for formal events.',
          price: 199.99,
          rating: 4.9,
          reviewCount: 87,
          images: [AppAssets.prodDress2, AppAssets.prodDress1],
          category: 'women',
          sizes: ['XS', 'S', 'M', 'L'],
          colors: ['#0D1650', '#1a0a00', '#C9956B'],
          isFeatured: true,
          stock: 15,
        ),
        Product(
          id: 'p003',
          name: 'Casual Linen Top',
          brand: 'BELLDI',
          description:
              'Lightweight linen top for effortless everyday style. Pairs beautifully with jeans or tailored trousers.',
          price: 39.99,
          originalPrice: 59.99,
          rating: 4.5,
          reviewCount: 156,
          images: [AppAssets.prodTop1, AppAssets.prodBlouse1],
          category: 'women',
          sizes: ['XS', 'S', 'M', 'L', 'XL', 'XXL'],
          colors: ['#FFFFFF', '#F5E6D3', '#A0AABF'],
          isNew: true,
          stock: 78,
        ),
        Product(
          id: 'p004',
          name: 'Pleated Mini Skirt',
          brand: 'BELLDI',
          description:
              'Trendy pleated mini skirt that transitions seamlessly from day to night.',
          price: 54.99,
          rating: 4.6,
          reviewCount: 98,
          images: [AppAssets.prodSkirt1],
          category: 'women',
          sizes: ['XS', 'S', 'M', 'L'],
          colors: ['#1A2766', '#C9956B', '#2d1a00'],
          stock: 34,
        ),
        Product(
          id: 'p005',
          name: 'Leather Biker Jacket',
          brand: 'BELLDI',
          description:
              'Iconic leather biker jacket with a modern silhouette. A wardrobe essential for every fashion lover.',
          price: 249.99,
          originalPrice: 349.99,
          rating: 4.9,
          reviewCount: 312,
          images: [AppAssets.prodJacket1, AppAssets.prodBlouse1],
          category: 'women',
          sizes: ['XS', 'S', 'M', 'L', 'XL'],
          colors: ['#1a1a1a', '#8B4513', '#C9956B'],
          isFeatured: true,
          stock: 22,
        ),
        Product(
          id: 'p006',
          name: 'Chiffon Blouse',
          brand: 'BELLDI',
          description:
              'Delicate chiffon blouse with subtle ruffled detailing. Elegant and versatile for any occasion.',
          price: 49.99,
          rating: 4.4,
          reviewCount: 73,
          images: [AppAssets.prodBlouse1, AppAssets.prodTop1],
          category: 'women',
          sizes: ['XS', 'S', 'M', 'L'],
          colors: ['#FFFFFF', '#F5E6D3', '#DFB896'],
          isNew: true,
          stock: 55,
        ),
        // Men
        Product(
          id: 'p007',
          name: 'Classic Wool Suit',
          brand: 'BELLDI',
          description:
              'Timeless two-piece wool suit tailored for the modern gentleman. Impeccable fit and superior craftsmanship.',
          price: 449.99,
          originalPrice: 599.99,
          rating: 4.9,
          reviewCount: 189,
          images: [AppAssets.prodSuit1],
          category: 'men',
          sizes: ['38', '40', '42', '44', '46'],
          colors: ['#1a1a1a', '#0D1650', '#5C4033'],
          isFeatured: true,
          stock: 18,
        ),
        Product(
          id: 'p008',
          name: 'Premium Oxford Shirt',
          brand: 'BELLDI',
          description:
              'Expertly crafted Oxford shirt in premium cotton. A versatile essential for the modern wardrobe.',
          price: 79.99,
          rating: 4.7,
          reviewCount: 245,
          images: [AppAssets.prodShirt1, AppAssets.prodSuit1],
          category: 'men',
          sizes: ['S', 'M', 'L', 'XL', 'XXL'],
          colors: ['#FFFFFF', '#A0AABF', '#0D1650'],
          isNew: true,
          stock: 65,
        ),
        Product(
          id: 'p009',
          name: 'Slim Fit Trousers',
          brand: 'BELLDI',
          description:
              'Modern slim-fit trousers in premium stretch fabric. Sophisticated comfort for all-day wear.',
          price: 99.99,
          originalPrice: 139.99,
          rating: 4.6,
          reviewCount: 134,
          images: [AppAssets.prodTrousers1],
          category: 'men',
          sizes: ['28', '30', '32', '34', '36'],
          colors: ['#1a1a1a', '#3a3a3a', '#5C4033'],
          stock: 48,
        ),
        Product(
          id: 'p010',
          name: 'Cashmere Overcoat',
          brand: 'BELLDI',
          description:
              'Luxurious cashmere blend overcoat. The epitome of refined winter dressing.',
          price: 599.99,
          rating: 4.9,
          reviewCount: 67,
          images: [AppAssets.prodCoat1, AppAssets.prodSuit1],
          category: 'men',
          sizes: ['S', 'M', 'L', 'XL'],
          colors: ['#5C4033', '#1a1a1a', '#C9956B'],
          isFeatured: true,
          stock: 12,
        ),
        // Accessories
        Product(
          id: 'p011',
          name: 'Structured Tote Bag',
          brand: 'BELLDI',
          description:
              'Sophisticated structured tote in genuine leather. Spacious enough for everything you need.',
          price: 179.99,
          originalPrice: 249.99,
          rating: 4.8,
          reviewCount: 298,
          images: [AppAssets.prodBag1, AppAssets.prodBag2],
          category: 'accessories',
          sizes: ['One Size'],
          colors: ['#C9956B', '#1a1a1a', '#FFFFFF'],
          isFeatured: true,
          stock: 30,
        ),
        Product(
          id: 'p012',
          name: 'Crossbody Mini Bag',
          brand: 'BELLDI',
          description:
              'Chic mini crossbody bag with an adjustable chain strap. Perfect for evenings out.',
          price: 89.99,
          rating: 4.7,
          reviewCount: 156,
          images: [AppAssets.prodBag2, AppAssets.prodBag1],
          category: 'accessories',
          sizes: ['One Size'],
          colors: ['#C9956B', '#0D1650', '#1a1a1a'],
          isNew: true,
          stock: 25,
        ),
        Product(
          id: 'p013',
          name: 'Gold Luxury Watch',
          brand: 'BELLDI',
          description:
              'Statement timepiece with a minimalist gold dial and premium leather strap.',
          price: 299.99,
          rating: 4.9,
          reviewCount: 432,
          images: [AppAssets.prodWatch1],
          category: 'accessories',
          sizes: ['One Size'],
          colors: ['#C9956B', '#DFB896'],
          isFeatured: true,
          stock: 20,
        ),
        Product(
          id: 'p014',
          name: 'Cashmere Scarf',
          brand: 'BELLDI',
          description:
              'Ultra-soft cashmere scarf in a timeless design. A luxury accessory for all seasons.',
          price: 69.99,
          originalPrice: 99.99,
          rating: 4.6,
          reviewCount: 88,
          images: [AppAssets.prodScarf1],
          category: 'accessories',
          sizes: ['One Size'],
          colors: ['#C9956B', '#0D1650', '#FFFFFF'],
          stock: 45,
        ),
      ];

  static List<Product> get featuredProducts =>
      products.where((p) => p.isFeatured).toList();

  static List<Product> get newArrivals =>
      products.where((p) => p.isNew).toList();

  static List<Product> getByCategory(String categoryId) =>
      products.where((p) => p.category == categoryId).toList();
}
