import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/auth_provider.dart';
import '../login_v1_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    
    final displayName = user?.displayName ?? 'Guest User';
    final email = user?.email ?? 'Not signed in';
    final photoUrl = user?.photoURL;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Profile', style: AppTextStyles.headlineLarge),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
        child: Column(
          children: [
            const SizedBox(height: 8),

            // Avatar + Name
            Center(
              child: Column(children: [
                Stack(
                  children: [
                    Container(
                      width: 96, height: 96,
                      decoration: BoxDecoration(
                        gradient: AppColors.accentGradient,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: AppColors.accent.withOpacity(0.4), blurRadius: 20, spreadRadius: 4)],
                        image: photoUrl != null 
                          ? DecorationImage(
                              image: NetworkImage(photoUrl),
                              fit: BoxFit.cover,
                            ) 
                          : null,
                      ),
                      child: photoUrl == null 
                        ? const Icon(Icons.person_rounded, color: Colors.white, size: 52) 
                        : null,
                    ),
                    Positioned(
                      right: 0, bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: AppColors.surface, shape: BoxShape.circle,
                          border: Border.all(color: AppColors.background, width: 2)),
                        child: const Icon(Icons.camera_alt_outlined, color: AppColors.accent, size: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(displayName, style: AppTextStyles.headlineLarge),
                const SizedBox(height: 4),
                Text(email, style: AppTextStyles.bodyMedium),
                const SizedBox(height: 16),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  _StatChip(label: 'Orders', value: '12'),
                  const SizedBox(width: 16),
                  _StatChip(label: 'Wishlist', value: '24'),
                  const SizedBox(width: 16),
                  _StatChip(label: 'Reviews', value: '8'),
                ]),
              ]),
            ),
            const SizedBox(height: 28),

            // Edit Profile Button
            OutlinedButton.icon(
              icon: const Icon(Icons.edit_outlined, size: 16),
              label: const Text('Edit Profile'),
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 44),
                foregroundColor: AppColors.accent,
                side: const BorderSide(color: AppColors.accent),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 28),

            // Menu Sections
            _SectionHeader('Shopping'),
            _MenuItem(icon: Icons.shopping_bag_outlined, label: 'My Orders', badge: '3'),
            _MenuItem(icon: Icons.local_offer_outlined, label: 'Vouchers & Offers'),
            _MenuItem(icon: Icons.star_border_rounded, label: 'My Reviews'),
            const SizedBox(height: 20),

            _SectionHeader('Account'),
            _MenuItem(icon: Icons.location_on_outlined, label: 'Saved Addresses'),
            _MenuItem(icon: Icons.credit_card_outlined, label: 'Payment Methods'),
            _MenuItem(icon: Icons.notifications_outlined, label: 'Notifications'),
            const SizedBox(height: 20),

            _SectionHeader('About'),
            _MenuItem(icon: Icons.help_outline_rounded, label: 'Help & FAQ'),
            _MenuItem(icon: Icons.privacy_tip_outlined, label: 'Privacy Policy'),
            _MenuItem(icon: Icons.description_outlined, label: 'Terms of Service'),
            const SizedBox(height: 24),

            // Sign Out
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.error.withOpacity(0.3)),
              ),
              child: ListTile(
                leading: const Icon(Icons.logout_rounded, color: AppColors.error),
                title: Text('Sign Out', style: GoogleFonts.inter(
                  fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.error)),
                onTap: () async {
                  await auth.signOut();
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginV1Screen()),
                      (route) => false,
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            Text('BELLDI Fashion Store v1.0.0',
              style: GoogleFonts.inter(fontSize: 11, color: AppColors.textHint)),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  const _StatChip({required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Text(value, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.accent)),
      Text(label, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary)),
    ]),
  );
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Align(alignment: Alignment.centerLeft,
      child: Text(title, style: GoogleFonts.inter(
        fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textHint, letterSpacing: 1))),
  );
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? badge;
  const _MenuItem({required this.icon, required this.label, this.badge});
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14)),
    child: ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: AppColors.accent, size: 20),
      ),
      title: Text(label, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        if (badge != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(10)),
            child: Text(badge!, style: GoogleFonts.inter(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        const SizedBox(width: 4),
        const Icon(Icons.chevron_right_rounded, color: AppColors.textHint, size: 20),
      ]),
      onTap: () {},
    ),
  );
}
