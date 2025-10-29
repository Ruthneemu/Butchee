
import 'package:flutter/material.dart';
import 'package:myapp/core/constants/colors.dart';
import 'package:myapp/core/constants/typography.dart';
import 'package:myapp/features/customer/presentation/widgets/bottom_navigation.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for wishlist items
    final List<Map<String, String>> wishlistItems = [
      {'name': 'Prime Ribeye Steak', 'image': 'ribeye.png', 'price': '28.99'},
      {'name': 'Fresh Atlantic Salmon', 'image': 'salmon.png', 'price': '24.99'},
      {'name': 'Tender Goat Chops', 'image': 'goat_chops.png', 'price': '22.50'},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Wishlist', style: AppTypography.h2),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: wishlistItems.isEmpty
          ? _buildEmptyWishlist()
          : _buildWishlist(wishlistItems),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 2), // Assuming wishlist is the 3rd item
    );
  }

  Widget _buildEmptyWishlist() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.favorite_border,
            size: 80,
            color: AppColors.textGrey,
          ),
          const SizedBox(height: 20),
          const Text(
            'Your wishlist is empty',
            style: AppTypography.h2,
          ),
          const SizedBox(height: 10),
          Text(
            'Tap the heart on any product to save it here.',
            style: AppTypography.body.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWishlist(List<Map<String, String>> items) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTypography.borderRadius),
          ),
          child: ListTile(
            leading: Image.asset(
              'assets/images/${item['image']}',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.fastfood, size: 40, color: AppColors.primaryRed);
              },
            ),
            title: Text(item['name']!, style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
            subtitle: Text('\\\$${item['price']}', style: AppTypography.body.copyWith(color: AppColors.primaryRed)),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.error),
              onPressed: () {
                // Handle remove from wishlist
              },
            ),
          ),
        );
      },
    );
  }
}
