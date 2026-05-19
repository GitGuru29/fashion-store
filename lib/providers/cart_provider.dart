import 'package:flutter/foundation.dart';
import '../models/product.dart';

class CartItem {
  final Product product;
  int quantity;
  String selectedSize;
  String selectedColor;

  CartItem({
    required this.product,
    this.quantity = 1,
    required this.selectedSize,
    required this.selectedColor,
  });

  double get totalPrice => product.price * quantity;
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => _items.fold(0, (sum, item) => sum + item.totalPrice);

  double get shipping => subtotal > 100 ? 0 : 9.99;

  double get discount => _promoApplied ? subtotal * 0.1 : 0;

  double get total => subtotal + shipping - discount;

  bool _promoApplied = false;
  bool get promoApplied => _promoApplied;

  String _promoCode = '';
  String get promoCode => _promoCode;

  void addToCart(Product product, String size, String color) {
    final existingIndex = _items.indexWhere(
      (item) =>
          item.product.id == product.id &&
          item.selectedSize == size &&
          item.selectedColor == color,
    );

    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(
        product: product,
        selectedSize: size,
        selectedColor: color,
      ));
    }
    notifyListeners();
  }

  void removeFromCart(String productId, String size, String color) {
    _items.removeWhere(
      (item) =>
          item.product.id == productId &&
          item.selectedSize == size &&
          item.selectedColor == color,
    );
    notifyListeners();
  }

  void updateQuantity(String productId, String size, String color, int quantity) {
    final index = _items.indexWhere(
      (item) =>
          item.product.id == productId &&
          item.selectedSize == size &&
          item.selectedColor == color,
    );
    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
      notifyListeners();
    }
  }

  bool applyPromoCode(String code) {
    if (code.toUpperCase() == 'BELLDI10') {
      _promoApplied = true;
      _promoCode = code;
      notifyListeners();
      return true;
    }
    return false;
  }

  void removePromo() {
    _promoApplied = false;
    _promoCode = '';
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _promoApplied = false;
    _promoCode = '';
    notifyListeners();
  }

  bool isInCart(String productId) {
    return _items.any((item) => item.product.id == productId);
  }
}
