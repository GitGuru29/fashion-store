class Product {
  final String id;
  final String name;
  final String brand;
  final String description;
  final double price;
  final double? originalPrice;
  final double rating;
  final int reviewCount;
  final List<String> images;
  final String category;
  final List<String> sizes;
  final List<String> colors;
  final bool isNew;
  final bool isFeatured;
  final int stock;

  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.rating,
    required this.reviewCount,
    required this.images,
    required this.category,
    required this.sizes,
    required this.colors,
    this.isNew = false,
    this.isFeatured = false,
    required this.stock,
  });

  bool get isOnSale => originalPrice != null && originalPrice! > price;

  int get discountPercent {
    if (!isOnSale) return 0;
    return (((originalPrice! - price) / originalPrice!) * 100).round();
  }
}
