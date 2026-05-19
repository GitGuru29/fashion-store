import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/cart_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _promoController = TextEditingController();
  bool _promoError = false;

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('My Cart', style: AppTextStyles.headlineLarge),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          if (cart.items.isNotEmpty)
            TextButton(
              onPressed: () => _confirmClear(context, cart),
              child: Text('Clear', style: GoogleFonts.inter(color: AppColors.error, fontSize: 13)),
            ),
        ],
      ),
      body: cart.items.isEmpty
          ? _EmptyCart()
          : Column(children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  itemCount: cart.items.length,
                  itemBuilder: (context, i) {
                    final item = cart.items[i];
                    return Dismissible(
                      key: Key('${item.product.id}_${item.selectedSize}_${item.selectedColor}'),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(18)),
                        child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 28),
                      ),
                      onDismissed: (_) => cart.removeFromCart(item.product.id, item.selectedSize, item.selectedColor),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(18)),
                        child: Row(children: [
                          // Product image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: SizedBox(
                              width: 80, height: 90,
                              child: Image.network(item.product.images.first, fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(color: AppColors.surface,
                                  child: const Icon(Icons.checkroom, color: AppColors.textHint, size: 32))),
                            ),
                          ),
                          const SizedBox(width: 14),
                          // Details
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(item.product.name, style: GoogleFonts.inter(
                                fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                                maxLines: 2, overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 4),
                              Row(children: [
                                Text('Size: ', style: AppTextStyles.labelSmall),
                                Text(item.selectedSize, style: GoogleFonts.inter(
                                  fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
                              ]),
                              const SizedBox(height: 4),
                              Text('\$${item.product.price.toStringAsFixed(2)}', style: AppTextStyles.priceSmall),
                            ]),
                          ),
                          // Quantity controls
                          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                            _QtyButton(
                              icon: Icons.add_rounded,
                              onTap: () => cart.updateQuantity(item.product.id, item.selectedSize, item.selectedColor, item.quantity + 1),
                            ),
                            const SizedBox(height: 8),
                            Text('${item.quantity}', style: GoogleFonts.inter(
                              fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                            const SizedBox(height: 8),
                            _QtyButton(
                              icon: Icons.remove_rounded,
                              onTap: () {
                                if (item.quantity == 1) {
                                  cart.removeFromCart(item.product.id, item.selectedSize, item.selectedColor);
                                } else {
                                  cart.updateQuantity(item.product.id, item.selectedSize, item.selectedColor, item.quantity - 1);
                                }
                              },
                            ),
                          ]),
                        ]),
                      ),
                    );
                  },
                ),
              ),

              // Order summary
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, -4))],
                ),
                child: Column(children: [
                  // Promo code
                  Row(children: [
                    Expanded(
                      child: TextField(
                        controller: _promoController,
                        style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Promo code (BELLDI10)',
                          hintStyle: GoogleFonts.inter(color: AppColors.textHint, fontSize: 13),
                          filled: true,
                          fillColor: AppColors.card,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          errorText: _promoError ? 'Invalid code' : null,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        final valid = cart.applyPromoCode(_promoController.text);
                        setState(() => _promoError = !valid);
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(70, 48),
                        padding: EdgeInsets.zero,
                        backgroundColor: AppColors.accent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Apply', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                    ),
                  ]),
                  const SizedBox(height: 16),

                  // Summary rows
                  _SummaryRow('Subtotal', '\$${cart.subtotal.toStringAsFixed(2)}'),
                  const SizedBox(height: 8),
                  _SummaryRow('Shipping', cart.shipping == 0 ? 'FREE' : '\$${cart.shipping.toStringAsFixed(2)}'),
                  if (cart.promoApplied) ...[
                    const SizedBox(height: 8),
                    _SummaryRow('Discount (10%)', '-\$${cart.discount.toStringAsFixed(2)}', isDiscount: true),
                  ],
                  const SizedBox(height: 12),
                  const Divider(color: AppColors.divider),
                  const SizedBox(height: 12),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('Total', style: AppTextStyles.headlineSmall),
                    Text('\$${cart.total.toStringAsFixed(2)}', style: AppTextStyles.price),
                  ]),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _showCheckoutSuccess(context, cart),
                    child: const Text('Proceed to Checkout'),
                  ),
                ]),
              ),
            ]),
    );
  }

  void _confirmClear(BuildContext context, CartProvider cart) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Clear Cart?', style: AppTextStyles.headlineSmall),
        content: Text('Remove all items from your cart?', style: AppTextStyles.bodyMedium),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.inter(color: AppColors.textSecondary))),
          TextButton(
            onPressed: () { cart.clearCart(); Navigator.pop(context); },
            child: Text('Clear', style: GoogleFonts.inter(color: AppColors.error))),
        ],
      ),
    );
  }

  void _showCheckoutSuccess(BuildContext context, CartProvider cart) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          const SizedBox(height: 16),
          Container(
            width: 72, height: 72,
            decoration: BoxDecoration(gradient: AppColors.accentGradient, shape: BoxShape.circle),
            child: const Icon(Icons.check_rounded, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 20),
          Text('Order Placed!', style: AppTextStyles.headlineMedium),
          const SizedBox(height: 8),
          Text('Thank you for shopping at BELLDI. Your order is confirmed!',
            style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () { cart.clearCart(); Navigator.pop(context); },
            child: const Text('Continue Shopping'),
          ),
        ]),
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyButton({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 28, height: 28,
      decoration: BoxDecoration(color: AppColors.surface, shape: BoxShape.circle,
        border: Border.all(color: AppColors.divider)),
      child: Icon(icon, color: AppColors.textPrimary, size: 16),
    ),
  );
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isDiscount;
  const _SummaryRow(this.label, this.value, {this.isDiscount = false});
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: AppTextStyles.bodyMedium),
      Text(value, style: GoogleFonts.inter(
        fontSize: 14, fontWeight: FontWeight.w500,
        color: isDiscount ? AppColors.success : AppColors.textPrimary)),
    ],
  );
}

class _EmptyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
        width: 100, height: 100,
        decoration: BoxDecoration(color: AppColors.surface, shape: BoxShape.circle),
        child: const Icon(Icons.shopping_bag_outlined, color: AppColors.textHint, size: 48),
      ),
      const SizedBox(height: 24),
      Text('Your cart is empty', style: AppTextStyles.headlineMedium),
      const SizedBox(height: 8),
      Text('Add items to start shopping', style: AppTextStyles.bodyMedium),
    ]),
  );
}
