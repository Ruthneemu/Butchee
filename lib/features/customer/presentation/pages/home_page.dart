import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/constants/colors.dart';
import 'package:myapp/core/constants/typography.dart';
import 'package:myapp/features/customer/bloc/cart/cart_bloc.dart';
import 'package:myapp/features/customer/bloc/cart/cart_event.dart';
import 'package:myapp/features/customer/bloc/cart/cart_state.dart';
import 'package:myapp/features/customer/domain/entities/product.dart';
import 'package:myapp/features/customer/bloc/product/product_bloc.dart';
import 'package:myapp/features/customer/bloc/product/product_event.dart';
import 'package:myapp/features/customer/bloc/product/product_state.dart';
import 'package:myapp/routes/app_routes.dart';
import 'package:myapp/features/customer/presentation/widgets/bottom_navigation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  
  // Animation controller for cart icon
  late AnimationController _cartAnimationController;
  late Animation<double> _cartScaleAnimation;

  // Banner carousel
  int _currentBannerIndex = 0;
  final PageController _bannerController = PageController();

  // Recent searches
  final List<String> _recentSearches = ['Ribeye', 'Chicken', 'Salmon'];

  final List<BannerData> _banners = [
    BannerData(
      title: 'Fresh Cuts Delivered\nDaily',
      subtitle: 'Premium quality meats',
      badge: 'New',
      color: AppColors.primaryRed,
    ),
    BannerData(
      title: '30% Off\nAll Seafood',
      subtitle: 'Limited time offer',
      badge: 'Sale',
      color: Colors.blue.shade700,
    ),
    BannerData(
      title: 'Free Delivery\nOrders Over \$50',
      subtitle: 'Save on shipping',
      badge: 'Deal',
      color: Colors.green.shade700,
    ),
  ];

  final List<Category> _categories = [
    Category(name: 'All', icon: Icons.grid_view),
    Category(name: 'Beef', icon: Icons.lunch_dining),
    Category(name: 'Goat', icon: Icons.pets),
    Category(name: 'Chicken', icon: Icons.egg),
    Category(name: 'Seafood', icon: Icons.set_meal),
  ];

  @override
  void initState() {
    super.initState();
    
    // Load products
    context.read<ProductBloc>().add(LoadProducts());
    
    // Initialize cart animation
    _cartAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _cartScaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        parent: _cartAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Auto-scroll banners
    Future.delayed(const Duration(seconds: 3), _autoScrollBanner);
  }

  void _autoScrollBanner() {
    if (!mounted) return;
    
    final nextPage = (_currentBannerIndex + 1) % _banners.length;
    _bannerController.animateToPage(
      nextPage,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    
    Future.delayed(const Duration(seconds: 3), _autoScrollBanner);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _cartAnimationController.dispose();
    _bannerController.dispose();
    super.dispose();
  }

  void _addToCart(Product product) {
    if (!product.inStock) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Sorry, ${product.name} is out of stock',
            style: AppTypography.body.copyWith(color: Colors.white),
          ),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    // Haptic feedback
    HapticFeedback.mediumImpact();

    // Add to cart via BLoC
    context.read<CartBloc>().add(AddToCart(product: product));

    // Animate cart icon
    _cartAnimationController.forward().then((_) {
      _cartAnimationController.reverse();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${product.name} added to cart',
                style: AppTypography.body.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'VIEW',
          textColor: Colors.white,
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.cart);
          },
        ),
      ),
    );
  }

  void _onCategoryTap(String category) {
    HapticFeedback.lightImpact();
    context.read<ProductBloc>().add(FilterProductsByCategory(category));
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Sort By',
                style: AppTypography.h2.copyWith(fontSize: 18),
              ),
            ),
            const SizedBox(height: 16),
            _buildSortOption('Featured', 'featured', Icons.star_outline),
            _buildSortOption('Price: Low to High', 'price_low', Icons.arrow_upward),
            _buildSortOption('Price: High to Low', 'price_high', Icons.arrow_downward),
            _buildSortOption('Name', 'name', Icons.sort_by_alpha),
            _buildSortOption('Rating', 'rating', Icons.grade),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String label, String value, IconData icon) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        final isSelected = state.sortBy == value;
        return ListTile(
          leading: Icon(
            icon,
            color: isSelected ? AppColors.primaryRed : AppColors.textGrey,
          ),
          title: Text(
            label,
            style: AppTypography.body.copyWith(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? AppColors.primaryRed : AppColors.textPrimary,
            ),
          ),
          trailing: isSelected
              ? Icon(Icons.check, color: AppColors.primaryRed)
              : null,
          onTap: () {
            context.read<ProductBloc>().add(SortProducts(value));
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void _onProductTap(Product product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Image with Stock Badge
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 200,
                              decoration: BoxDecoration(
                                color: AppColors.lightGray,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.fastfood,
                                color: AppColors.primaryRed.withOpacity(0.5),
                                size: 80,
                              ),
                            ),
                            if (!product.inStock)
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        'OUT OF STOCK',
                                        style: AppTypography.button.copyWith(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Product Name & Rating
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              product.name,
                              style: AppTypography.h2.copyWith(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          BlocBuilder<ProductBloc, ProductState>(
                            builder: (context, state) {
                              final isFavorite = state.favorites.contains(product.id);
                              return IconButton(
                                icon: Icon(
                                  isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: AppColors.primaryRed,
                                ),
                                onPressed: () {
                                  HapticFeedback.lightImpact();
                                  context.read<ProductBloc>().add(
                                    ToggleFavorite(product.id),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        isFavorite 
                                            ? 'Removed from favorites'
                                            : 'Added to favorites',
                                      ),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Rating & Reviews
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            product.rating.toString(),
                            style: AppTypography.body.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '(${product.reviews} reviews)',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.textGrey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Category & Weight
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryRed.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              product.category,
                              style: AppTypography.caption.copyWith(
                                color: AppColors.primaryRed,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.lightGray,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.scale,
                                  size: 14,
                                  color: AppColors.textGrey,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                    product.displayWeight,  // Changed from product.weight
                                    style: AppTypography.caption.copyWith(
                                    color: AppColors.textGrey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Description
                      Text(
                        'About',
                        style: AppTypography.h2.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.description,
                        style: AppTypography.body.copyWith(
                          fontSize: 15,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Price
                      Row(
                        children: [
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: AppTypography.h1.copyWith(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryRed,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'per ${product.weight}',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.textGrey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      // Add to Cart Button
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: product.inStock
                              ? () {
                                  _addToCart(product);
                                  Navigator.pop(context);
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryRed,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.grey[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            product.inStock ? 'Add to Cart' : 'Out of Stock',
                            style: AppTypography.button.copyWith(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductBloc>(
          create: (context) => ProductBloc()..add(LoadProducts()),
        ),
        BlocProvider<CartBloc>(
          create: (context) => CartBloc(),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              // Header Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // App Logo
                    Text(
                      'Butchee',
                      style: AppTypography.h2.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryRed,
                      ),
                    ),
                    // Action Icons
                    Row(
                      children: [
                        // Animated Cart Icon with BLoC
                        BlocBuilder<CartBloc, CartState>(
                          builder: (context, state) {
                            return Stack(
                              children: [
                                ScaleTransition(
                                  scale: _cartScaleAnimation,
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, AppRoutes.cart);
                                    },
                                    icon: Icon(
                                      Icons.shopping_cart_outlined,
                                      color: AppColors.primaryRed,
                                    ),
                                  ),
                                ),
                                if (state.itemCount > 0)
                                  Positioned(
                                    right: 8,
                                    top: 8,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryRed,
                                        shape: BoxShape.circle,
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 18,
                                        minHeight: 18,
                                      ),
                                      child: Text(
                                        '${state.itemCount}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.support);
                          },
                          icon: Icon(
                            Icons.chat_bubble_outline,
                            color: AppColors.primaryRed,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Scrollable Body Content
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    context.read<ProductBloc>().add(RefreshProducts());
                    await Future.delayed(const Duration(milliseconds: 500));
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Banner Carousel
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: SizedBox(
                            height: 160,
                            child: PageView.builder(
                              controller: _bannerController,
                              onPageChanged: (index) {
                                setState(() {
                                  _currentBannerIndex = index;
                                });
                              },
                              itemCount: _banners.length,
                              itemBuilder: (context, index) {
                                final banner = _banners[index];
                                return Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    color: banner.color,
                                    borderRadius: BorderRadius.circular(12),
                                    gradient: LinearGradient(
                                      colors: [
                                        banner.color,
                                        banner.color.withOpacity(0.7),
                                      ],
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: 16,
                                        right: 16,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            banner.badge,
                                            style: AppTypography.caption.copyWith(
                                              color: banner.color,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              banner.title,
                                              style: AppTypography.h2.copyWith(
                                                color: Colors.white,
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                height: 1.2,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              banner.subtitle,
                                              style: AppTypography.caption.copyWith(
                                                color: Colors.white.withOpacity(0.9),
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Banner Indicators
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _banners.length,
                            (index) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: _currentBannerIndex == index ? 24 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _currentBannerIndex == index
                                    ? AppColors.primaryRed
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Search Bar with Recent Searches
                        BlocBuilder<ProductBloc, ProductState>(
                          builder: (context, state) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 10,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: TextField(
                                      controller: _searchController,
                                      focusNode: _searchFocusNode,
                                      onChanged: (value) {
                                        context.read<ProductBloc>().add(
                                          SearchProducts(value),
                                        );
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'Search for products',
                                        hintStyle: AppTypography.caption.copyWith(
                                          color: AppColors.textGrey,
                                          fontSize: 15,
                                        ),
                                        prefixIcon: Icon(
                                          Icons.search,
                                          color: AppColors.primaryRed,
                                          size: 22,
                                        ),
                                        suffixIcon: state.searchQuery.isNotEmpty
                                            ? IconButton(
                                                icon: Icon(
                                                  Icons.clear,
                                                  color: AppColors.textGrey,
                                                ),
                                                onPressed: () {
                                                  _searchController.clear();
                                                  context.read<ProductBloc>().add(
                                                    const SearchProducts(''),
                                                  );
                                                },
                                              )
                                            : null,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide.none,
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (_searchFocusNode.hasFocus && state.searchQuery.isEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: Wrap(
                                        spacing: 8,
                                        children: _recentSearches
                                            .map((search) => GestureDetector(
                                                  onTap: () {
                                                    _searchController.text = search;
                                                    context.read<ProductBloc>().add(
                                                      SearchProducts(search),
                                                    );
                                                  },
                                                  child: Chip(
                                                    label: Text(search),
                                                    avatar: Icon(
                                                      Icons.history,
                                                      size: 16,
                                                      color: AppColors.textGrey,
                                                    ),
                                                    backgroundColor: Colors.white,
                                                    side: BorderSide(
                                                      color: Colors.grey[300]!,
                                                    ),
                                                  ),
                                                ))
                                            .toList(),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),

                        // Categories
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Categories',
                            style: AppTypography.h2.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        BlocBuilder<ProductBloc, ProductState>(
                          builder: (context, state) {
                            return SizedBox(
                              height: 100,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: _categories.length,
                                itemBuilder: (context, index) {
                                  final category = _categories[index];
                                  final isSelected = state.selectedCategory == category.name;

                                  return Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: InkWell(
                                      onTap: () => _onCategoryTap(category.name),
                                      borderRadius: BorderRadius.circular(12),
                                      splashColor: AppColors.primaryRed.withOpacity(0.2),
                                      highlightColor: AppColors.primaryRed.withOpacity(0.1),
                                      child: Column(
                                        children: [
                                          AnimatedContainer(
                                            duration: const Duration(milliseconds: 200),
                                            width: 70,
                                            height: 70,
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? AppColors.primaryRed
                                                  : Colors.white,
                                              borderRadius: BorderRadius.circular(12),
                                              boxShadow: isSelected
                                                  ? [
                                                      BoxShadow(
                                                        color: AppColors.primaryRed
                                                            .withOpacity(0.3),
                                                        blurRadius: 8,
                                                        offset: const Offset(0, 4),
                                                      ),
                                                    ]
                                                  : [
                                                      BoxShadow(
                                                        color: Colors.black.withOpacity(0.05),
                                                        blurRadius: 6,
                                                        offset: const Offset(0, 2),
                                                      ),
                                                    ],
                                            ),
                                            child: Icon(
                                              category.icon,
                                              color: isSelected
                                                  ? Colors.white
                                                  : AppColors.primaryRed,
                                              size: 32,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            category.name,
                                            style: AppTypography.caption.copyWith(
                                              fontSize: 12,
                                              fontWeight: isSelected
                                                  ? FontWeight.w600
                                                  : FontWeight.w500,
                                              color: isSelected
                                                  ? AppColors.primaryRed
                                                  : AppColors.textPrimary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),

                        // Products Header with Sort
                        BlocBuilder<ProductBloc, ProductState>(
                          builder: (context, state) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      state.searchQuery.isNotEmpty
                                          ? 'Results (${state.filteredProducts.length})'
                                          : state.selectedCategory == 'All'
                                              ? 'Featured Products'
                                              : '${state.selectedCategory} Products',
                                      style: AppTypography.h2.copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  OutlinedButton.icon(
                                    onPressed: _showSortOptions,
                                    icon: Icon(
                                      Icons.sort,
                                      size: 18,
                                      color: AppColors.primaryRed,
                                    ),
                                    label: Text(
                                      'Sort',
                                      style: AppTypography.button.copyWith(
                                        fontSize: 13,
                                        color: AppColors.primaryRed,
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: AppColors.primaryRed),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),

                        // Product List with BLoC
                        BlocBuilder<ProductBloc, ProductState>(
                          builder: (context, state) {
                            if (state.status == ProductStatus.loading) {
                              return const Padding(
                                padding: EdgeInsets.all(32.0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            if (state.status == ProductStatus.error) {
                              return Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        size: 64,
                                        color: AppColors.textGrey,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'Error loading products',
                                        style: AppTypography.body.copyWith(
                                          color: AppColors.textGrey,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      ElevatedButton(
                                        onPressed: () {
                                          context.read<ProductBloc>().add(LoadProducts());
                                        },
                                        child: const Text('Retry'),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            if (state.filteredProducts.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.search_off,
                                        size: 64,
                                        color: AppColors.textGrey,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'No products found',
                                        style: AppTypography.body.copyWith(
                                          color: AppColors.textGrey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Try adjusting your search or filters',
                                        style: AppTypography.caption.copyWith(
                                          color: AppColors.textGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: state.filteredProducts.length,
                              itemBuilder: (context, index) {
                                final product = state.filteredProducts[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: GestureDetector(
                                    onTap: () => _onProductTap(product),
                                    child: Hero(
                                      tag: 'product-${product.id}',
                                      child: Material(
                                        color: Colors.transparent,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(12),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.05),
                                                blurRadius: 10,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            children: [
                                              // Product Image with Stock Badge
                                              Stack(
                                                children: [
                                                  Container(
                                                    width: 100,
                                                    height: 100,
                                                    decoration: BoxDecoration(
                                                      color: AppColors.lightGray,
                                                      borderRadius: const BorderRadius.only(
                                                        topLeft: Radius.circular(12),
                                                        bottomLeft: Radius.circular(12),
                                                      ),
                                                    ),
                                                    child: Icon(
                                                      Icons.fastfood,
                                                      color: AppColors.primaryRed
                                                          .withOpacity(0.5),
                                                      size: 40,
                                                    ),
                                                  ),
                                                  if (!product.inStock)
                                                    Positioned.fill(
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          color: Colors.black.withOpacity(0.6),
                                                          borderRadius: const BorderRadius.only(
                                                            topLeft: Radius.circular(12),
                                                            bottomLeft: Radius.circular(12),
                                                          ),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            'OUT OF\nSTOCK',
                                                            textAlign: TextAlign.center,
                                                            style: const TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 10,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                              const SizedBox(width: 12),
                                              // Product Info
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        product.name,
                                                        style: AppTypography.body.copyWith(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w600,
                                                          color: AppColors.textPrimary,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.star,
                                                            color: Colors.amber,
                                                            size: 14,
                                                          ),
                                                          const SizedBox(width: 4),
                                                          Text(
                                                            product.rating.toString(),
                                                            style: AppTypography.caption.copyWith(
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                          const SizedBox(width: 4),
                                                          Text(
                                                            '(${product.reviews})',
                                                            style: AppTypography.caption.copyWith(
                                                              fontSize: 11,
                                                              color: AppColors.textGrey,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                            'per ${product.displayWeight}',  // Changed from product.weight
                                                            style: AppTypography.caption.copyWith(
                                                              color: AppColors.textGrey,
                                                            ),
                                                          ),

                                                      const SizedBox(height: 6),
                                                      Text(
                                                        '\$${product.price.toStringAsFixed(2)}',
                                                        style: AppTypography.h2.copyWith(
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.bold,
                                                          color: AppColors.primaryRed,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              // Add to Cart Button
                                              Padding(
                                                padding: const EdgeInsets.all(12.0),
                                                child: ElevatedButton(
                                                  onPressed: product.inStock
                                                      ? () => _addToCart(product)
                                                      : null,
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: AppColors.primaryRed,
                                                    foregroundColor: Colors.white,
                                                    disabledBackgroundColor: Colors.grey[300],
                                                    padding: const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 10,
                                                    ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    elevation: 0,
                                                  ),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Icon(
                                                        Icons.add_shopping_cart,
                                                        size: 16,
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        'Add',
                                                        style: AppTypography.button.copyWith(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const CustomBottomNavBar(
          currentIndex: 0,
        ),
      ),
    );
  }
}

// Data Models
class Category {
  final String name;
  final IconData icon;

  Category({
    required this.name,
    required this.icon,
  });
}

class BannerData {
  final String title;
  final String subtitle;
  final String badge;
  final Color color;

  BannerData({
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.color,
  });
}