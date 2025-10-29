import 'package:flutter/material.dart';
import 'package:myapp/core/constants/colors.dart';
import 'package:myapp/core/constants/typography.dart';
import 'package:myapp/routes/app_routes.dart';
import 'package:myapp/features/customer/presentation/widgets/bottom_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductListingPage extends StatefulWidget {
  const ProductListingPage({super.key});

  @override
  State<ProductListingPage> createState() => _ProductListingPageState();
}

class _ProductListingPageState extends State<ProductListingPage> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  int _cartItemsCount = 0;
  final TextEditingController _searchController = TextEditingController();
  String _sortOption = 'Default';
  bool _isFiltering = false;
  double _minPrice = 0;
  double _maxPrice = 100;
  bool _inStockOnly = false;
  double _minRating = 0;
  Set<String> _wishlistItems = {};

  final List<String> _categories = [
    'All',
    'Beef',
    'Chicken',
    'Pork',
    'Lamb',
    'Seafood',
  ];

  final List<String> _sortOptions = [
    'Default',
    'Price: Low to High',
    'Price: High to Low',
    'Name: A to Z',
    'Name: Z to A',
    'Highest Rated',
  ];

  final Map<String, IconData> _categoryIcons = {
    'All': Icons.fastfood,
    'Beef': Icons.emoji_nature,
    'Chicken': Icons.egg,
    'Pork': Icons.set_meal,
    'Lamb': Icons.pets,
    'Seafood': Icons.water,
  };

  final List<Product> _allProducts = [
    Product(
      id: '1',
      name: 'Prime Ribeye Steak',
      price: 25.99,
      imageUrl: 'https://example.com/images/ribeye.jpg',
      category: 'Beef',
      description: 'Premium quality ribeye steak, perfectly marbled for maximum flavor',
      weight: '500g',
      inStock: true,
      rating: 4.8,
      reviewCount: 124,
    ),
    Product(
      id: '2',
      name: 'Organic Chicken Breast',
      price: 12.50,
      imageUrl: 'https://example.com/images/chicken.jpg',
      category: 'Chicken',
      description: 'Fresh organic chicken breast, free-range and hormone-free',
      weight: '400g',
      inStock: true,
      rating: 4.5,
      reviewCount: 89,
    ),
    Product(
      id: '3',
      name: 'Artisan Pork Sausages',
      price: 8.75,
      imageUrl: 'https://example.com/images/sausages.jpg',
      category: 'Pork',
      description: 'Handcrafted pork sausages with traditional herbs and spices',
      weight: '300g',
      inStock: true,
      rating: 4.3,
      reviewCount: 56,
    ),
    Product(
      id: '4',
      name: 'Grass-Fed Lamb Chops',
      price: 28.00,
      imageUrl: 'https://example.com/images/lamb.jpg',
      category: 'Lamb',
      description: 'Tender grass-fed lamb chops, perfect for grilling',
      weight: '600g',
      inStock: true,
      rating: 4.7,
      reviewCount: 42,
    ),
    Product(
      id: '5',
      name: 'T-Bone Steak',
      price: 32.99,
      imageUrl: 'https://example.com/images/tbone.jpg',
      category: 'Beef',
      description: 'Premium T-bone steak with both strip steak and tenderloin',
      weight: '700g',
      inStock: false,
      rating: 4.9,
      reviewCount: 67,
    ),
    Product(
      id: '6',
      name: 'Chicken Wings',
      price: 9.99,
      imageUrl: 'https://example.com/images/wings.jpg',
      category: 'Chicken',
      description: 'Fresh chicken wings, perfect for frying or grilling',
      weight: '500g',
      inStock: true,
      rating: 4.2,
      reviewCount: 78,
    ),
    Product(
      id: '7',
      name: 'Pork Belly',
      price: 15.50,
      imageUrl: 'https://example.com/images/pork_belly.jpg',
      category: 'Pork',
      description: 'Premium pork belly cuts with perfect fat ratio',
      weight: '800g',
      inStock: true,
      rating: 4.6,
      reviewCount: 91,
    ),
    Product(
      id: '8',
      name: 'Atlantic Salmon',
      price: 24.99,
      imageUrl: 'https://example.com/images/salmon.jpg',
      category: 'Seafood',
      description: 'Fresh Atlantic salmon fillet, rich in omega-3',
      weight: '400g',
      inStock: true,
      rating: 4.7,
      reviewCount: 103,
    ),
    Product(
      id: '9',
      name: 'Beef Tenderloin',
      price: 38.00,
      imageUrl: 'https://example.com/images/tenderloin.jpg',
      category: 'Beef',
      description: 'Premium beef tenderloin, the most tender cut of beef',
      weight: '500g',
      inStock: true,
      rating: 4.9,
      reviewCount: 87,
    ),
    Product(
      id: '10',
      name: 'Chicken Thighs',
      price: 8.99,
      imageUrl: 'https://example.com/images/thighs.jpg',
      category: 'Chicken',
      description: 'Bone-in chicken thighs, juicy and flavorful',
      weight: '600g',
      inStock: true,
      rating: 4.4,
      reviewCount: 65,
    ),
    Product(
      id: '11',
      name: 'Lamb Rack',
      price: 35.00,
      imageUrl: 'https://example.com/images/lamb_rack.jpg',
      category: 'Lamb',
      description: 'French-trimmed lamb rack, perfect for special occasions',
      weight: '700g',
      inStock: true,
      rating: 4.8,
      reviewCount: 34,
    ),
    Product(
      id: '12',
      name: 'Shrimp',
      price: 18.99,
      imageUrl: 'https://example.com/images/shrimp.jpg',
      category: 'Seafood',
      description: 'Large tiger shrimp, peeled and deveined',
      weight: '300g',
      inStock: true,
      rating: 4.5,
      reviewCount: 76,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadCartCount();
    _loadWishlistItems();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCartCount() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _cartItemsCount = prefs.getInt('cart_count') ?? 0;
    });
  }

  Future<void> _loadWishlistItems() async {
    final prefs = await SharedPreferences.getInstance();
    final wishlist = prefs.getStringList('wishlist') ?? [];
    setState(() {
      _wishlistItems = Set<String>.from(wishlist);
    });
  }

  Future<void> _saveWishlistItems() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('wishlist', _wishlistItems.toList());
  }

  List<Product> get _filteredProducts {
    List<Product> result = List<Product>.from(_allProducts);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      result = result.where((product) =>
          product.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }

    // Apply category filter
    if (_selectedCategory != 'All') {
      result = result.where((product) =>
          product.category == _selectedCategory).toList();
    }

    // Apply stock filter
    if (_inStockOnly) {
      result = result.where((product) => product.inStock).toList();
    }

    // Apply price filter
    result = result.where((product) =>
        product.price >= _minPrice && product.price <= _maxPrice).toList();

    // Apply rating filter
    if (_minRating > 0) {
      result = result.where((product) =>
          product.rating >= _minRating).toList();
    }

    // Apply sorting
    switch (_sortOption) {
      case 'Price: Low to High':
        result.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price: High to Low':
        result.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Name: A to Z':
        result.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Name: Z to A':
        result.sort((a, b) => b.name.compareTo(a.name));
        break;
      case 'Highest Rated':
        result.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      default:
        // Keep default order
        break;
    }

    return result;
  }

  void _addToCart(Product product, {int quantity = 1}) async {
    final prefs = await SharedPreferences.getInstance();
    final newCount = _cartItemsCount + quantity;
    await prefs.setInt('cart_count', newCount);

    setState(() {
      _cartItemsCount = newCount;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$quantity ${quantity > 1 ? 'items' : 'item'} added to cart',
          style: AppTypography.body.copyWith(color: Colors.white),
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

  void _toggleWishlist(String productId) async {
    setState(() {
      if (_wishlistItems.contains(productId)) {
        _wishlistItems.remove(productId);
      } else {
        _wishlistItems.add(productId);
      }
    });
    await _saveWishlistItems();
  }

  void _viewProductDetails(Product product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProductDetailSheet(
        product: product,
        isInWishlist: _wishlistItems.contains(product.id),
        onAddToCart: (quantity) => _addToCart(product, quantity: quantity),
        onToggleWishlist: () => _toggleWishlist(product.id),
      ),
    );
  }

  void _showFilterDialog() {
    double tempMinPrice = _minPrice;
    double tempMaxPrice = _maxPrice;
    bool tempInStockOnly = _inStockOnly;
    double tempMinRating = _minRating;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(
            'Filter Products',
            style: AppTypography.h2.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Price Range
                Text(
                  'Price Range',
                  style: AppTypography.body.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '\$${tempMinPrice.toStringAsFixed(0)}',
                        style: AppTypography.caption,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '\$${tempMaxPrice.toStringAsFixed(0)}',
                        style: AppTypography.caption,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                RangeSlider(
                  values: RangeValues(tempMinPrice, tempMaxPrice),
                  min: 0,
                  max: 100,
                  divisions: 20,
                  activeColor: AppColors.primaryRed,
                  onChanged: (values) {
                    setState(() {
                      tempMinPrice = values.start;
                      tempMaxPrice = values.end;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Stock Status
                Row(
                  children: [
                    Checkbox(
                      value: tempInStockOnly,
                      activeColor: AppColors.primaryRed,
                      onChanged: (value) {
                        setState(() {
                          tempInStockOnly = value ?? false;
                        });
                      },
                    ),
                    Text(
                      'In Stock Only',
                      style: AppTypography.body,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Rating Filter
                Text(
                  'Minimum Rating',
                  style: AppTypography.body.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      tempMinRating.toStringAsFixed(1),
                      style: AppTypography.caption,
                    ),
                    Expanded(
                      child: Slider(
                        value: tempMinRating,
                        min: 0,
                        max: 5,
                        divisions: 10,
                        activeColor: AppColors.primaryRed,
                        onChanged: (value) {
                          setState(() {
                            tempMinRating = value;
                          });
                        },
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(5, (index) {
                        return Icon(
                          index < tempMinRating.floor()
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 16,
                        );
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: AppTypography.button.copyWith(
                  color: AppColors.textGrey,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _minPrice = tempMinPrice;
                  _maxPrice = tempMaxPrice;
                  _inStockOnly = tempInStockOnly;
                  _minRating = tempMinRating;
                  _isFiltering = _minPrice > 0 || _maxPrice < 100 || _inStockOnly || _minRating > 0;
                });
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryRed,
              ),
              child: Text(
                'Apply',
                style: AppTypography.button.copyWith(
                  color: AppColors.primaryRed,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSortDialog() {
    String tempSortOption = _sortOption;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Sort Products',
          style: AppTypography.h2.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _sortOptions.length,
            itemBuilder: (context, index) {
              final option = _sortOptions[index];
              return RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: tempSortOption,
                activeColor: AppColors.primaryRed,
                onChanged: (value) {
                  setState(() {
                    tempSortOption = value!;
                  });
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Cancel',
              style: AppTypography.button.copyWith(
                color: AppColors.textGrey,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _sortOption = tempSortOption;
              });
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primaryRed,
            ),
            child: Text(
              'Apply',
              style: AppTypography.button.copyWith(
                color: AppColors.primaryRed,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddProductDialog() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final weightController = TextEditingController();
    String selectedCategory = 'Beef';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Quick Add Product',
          style: AppTypography.h2.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Product Name',
                  labelStyle: AppTypography.caption.copyWith(
                    color: AppColors.textGrey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.primaryRed),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Price',
                  labelStyle: AppTypography.caption.copyWith(
                    color: AppColors.textGrey,
                  ),
                  prefixText: '\$ ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.primaryRed),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: weightController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Weight',
                  labelStyle: AppTypography.caption.copyWith(
                    color: AppColors.textGrey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.primaryRed),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                  labelStyle: AppTypography.caption.copyWith(
                    color: AppColors.textGrey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.primaryRed),
                  ),
                ),
                items: _categories
                    .where((cat) => cat != 'All')
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  selectedCategory = value!;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTypography.button.copyWith(
                color: AppColors.textGrey,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  priceController.text.isNotEmpty) {
                setState(() {
                  _allProducts.add(
                    Product(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: nameController.text,
                      price: double.tryParse(priceController.text) ?? 0.0,
                      imageUrl: 'https://example.com/images/custom.jpg',
                      category: selectedCategory,
                      description: 'Custom product',
                      weight: weightController.text.isNotEmpty ? weightController.text : '500g',
                      inStock: true,
                      rating: 4.5,
                      reviewCount: 0,
                    ),
                  );
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Product added successfully',
                      style: AppTypography.body.copyWith(color: Colors.white),
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Add', style: AppTypography.button),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 600 ? 3 : 2;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Butchee',
                    style: AppTypography.h2.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryRed,
                    ),
                  ),
                  Row(
                    children: [
                      // Wishlist Icon
                      Stack(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, AppRoutes.wishlist);
                            },
                            icon: Icon(
                              Icons.favorite_border_outlined,
                              color: AppColors.primaryRed,
                              size: 26,
                            ),
                          ),
                          if (_wishlistItems.isNotEmpty)
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
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  '${_wishlistItems.length}',
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
                      ),
                      // Cart Icon
                      Stack(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, AppRoutes.cart);
                            },
                            icon: Icon(
                              Icons.shopping_cart_outlined,
                              color: AppColors.primaryRed,
                              size: 26,
                            ),
                          ),
                          if (_cartItemsCount > 0)
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
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  '$_cartItemsCount',
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
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.lightGray.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search beef, chicken, pork...',
                    hintStyle: AppTypography.caption.copyWith(
                      color: AppColors.textGrey,
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(Icons.search, color: AppColors.textGrey),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_searchQuery.isNotEmpty)
                          IconButton(
                            icon: Icon(Icons.clear, color: AppColors.textGrey),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _searchQuery = '';
                              });
                            },
                          ),
                        IconButton(
                          icon: Icon(Icons.mic, color: AppColors.textGrey),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Voice search coming soon')),
                            );
                          },
                        ),
                      ],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: AppColors.lightGray.withOpacity(0.5),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Category Pills
            SizedBox(
              height: 45,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedCategory == _categories[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategory = _categories[index];
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryRed
                              : Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primaryRed
                                : AppColors.neutralGray.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _categoryIcons[_categories[index]] ?? Icons.fastfood,
                              size: 16,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.primaryRed,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _categories[index],
                              style: AppTypography.caption.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Results count and filter/sort options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_filteredProducts.length} ${_filteredProducts.length == 1 ? 'Product' : 'Products'}',
                    style: AppTypography.body.copyWith(
                      fontSize: 14,
                      color: AppColors.textGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      // Filter Button
                      TextButton.icon(
                        onPressed: _showFilterDialog,
                        icon: Icon(
                          Icons.filter_list,
                          size: 16,
                          color: _isFiltering ? AppColors.primaryRed : AppColors.textGrey,
                        ),
                        label: Text(
                          'Filter',
                          style: AppTypography.caption.copyWith(
                            color: _isFiltering ? AppColors.primaryRed : AppColors.textGrey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Sort Button
                      TextButton.icon(
                        onPressed: _showSortDialog,
                        icon: Icon(
                          Icons.sort,
                          size: 16,
                          color: _sortOption != 'Default' ? AppColors.primaryRed : AppColors.textGrey,
                        ),
                        label: Text(
                          'Sort',
                          style: AppTypography.caption.copyWith(
                            color: _sortOption != 'Default' ? AppColors.primaryRed : AppColors.textGrey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      // Clear Filters Button
                      if (_searchQuery.isNotEmpty || 
                          _selectedCategory != 'All' || 
                          _isFiltering ||
                          _sortOption != 'Default')
                        TextButton.icon(
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                              _selectedCategory = 'All';
                              _sortOption = 'Default';
                              _minPrice = 0;
                              _maxPrice = 100;
                              _inStockOnly = false;
                              _minRating = 0;
                              _isFiltering = false;
                            });
                          },
                          icon: Icon(
                            Icons.clear,
                            size: 16,
                            color: AppColors.primaryRed,
                          ),
                          label: Text(
                            'Clear',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.primaryRed,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Product Grid
            Expanded(
              child: _filteredProducts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _searchQuery = '';
                                _selectedCategory = 'All';
                                _sortOption = 'Default';
                                _minPrice = 0;
                                _maxPrice = 100;
                                _inStockOnly = false;
                                _minRating = 0;
                                _isFiltering = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryRed,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Reset Filters',
                              style: AppTypography.button,
                            ),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: _filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = _filteredProducts[index];
                        return ProductCard(
                          product: product,
                          isInWishlist: _wishlistItems.contains(product.id),
                          onTap: () => _viewProductDetails(product),
                          onAddToCart: () => _addToCart(product),
                          onToggleWishlist: () => _toggleWishlist(product.id),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddProductDialog,
        backgroundColor: AppColors.primaryRed,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 1, // Shop page index
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isInWishlist;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;
  final VoidCallback onToggleWishlist;

  const ProductCard({
    super.key,
    required this.product,
    required this.isInWishlist,
    required this.onTap,
    required this.onAddToCart,
    required this.onToggleWishlist,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Stack(
              children: [
                Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.lightGray.withOpacity(0.3),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: product.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: Icon(
                          Icons.fastfood,
                          size: 60,
                          color: AppColors.primaryRed.withOpacity(0.3),
                        ),
                      ),
                      errorWidget: (context, url, error) => Center(
                        child: Icon(
                          Icons.broken_image,
                          size: 60,
                          color: AppColors.primaryRed.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ),
                ),
                // Out of Stock Badge
                if (!product.inStock)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryRed,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Out of Stock',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                // Wishlist Button
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: onToggleWishlist,
                      icon: Icon(
                        isInWishlist ? Icons.favorite : Icons.favorite_border,
                        color: isInWishlist ? AppColors.primaryRed : AppColors.textGrey,
                        size: 18,
                      ),
                    ),
                  ),
                ),
                // Add to Cart Button
                if (product.inStock)
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.primaryRed,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryRed.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: onAddToCart,
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            // Product Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name
                    Text(
                      product.name,
                      style: AppTypography.body.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Product Weight
                    Text(
                      product.weight,
                      style: AppTypography.caption.copyWith(
                        fontSize: 12,
                        color: AppColors.textGrey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Rating
                    Row(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(5, (index) {
                            return Icon(
                              index < product.rating.floor()
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 12,
                            );
                          }),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${product.reviewCount})',
                          style: AppTypography.caption.copyWith(
                            fontSize: 10,
                            color: AppColors.textGrey,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Price
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: AppTypography.h2.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryRed,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductDetailSheet extends StatefulWidget {
  final Product product;
  final bool isInWishlist;
  final Function(int) onAddToCart;
  final VoidCallback onToggleWishlist;

  const ProductDetailSheet({
    super.key,
    required this.product,
    required this.isInWishlist,
    required this.onAddToCart,
    required this.onToggleWishlist,
  });

  @override
  State<ProductDetailSheet> createState() => _ProductDetailSheetState();
}

class _ProductDetailSheetState extends State<ProductDetailSheet> {
  int quantity = 1;
  late bool _isInWishlist;

  @override
  void initState() {
    super.initState();
    _isInWishlist = widget.isInWishlist;
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = widget.product.price * quantity;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
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
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  Stack(
                    children: [
                      Center(
                        child: Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            color: AppColors.lightGray,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: widget.product.imageUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Center(
                                child: Icon(
                                  Icons.fastfood,
                                  size: 80,
                                  color: AppColors.primaryRed.withOpacity(0.5),
                                ),
                              ),
                              errorWidget: (context, url, error) => Center(
                                child: Icon(
                                  Icons.broken_image,
                                  size: 80,
                                  color: AppColors.primaryRed.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Out of Stock Badge
                      if (!widget.product.inStock)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryRed,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'Out of Stock',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      // Wishlist Button
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              setState(() {
                                _isInWishlist = !_isInWishlist;
                              });
                              widget.onToggleWishlist();
                            },
                            icon: Icon(
                              _isInWishlist ? Icons.favorite : Icons.favorite_border,
                              color: _isInWishlist ? AppColors.primaryRed : AppColors.textGrey,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Product Name
                  Text(
                    widget.product.name,
                    style: AppTypography.h2.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Product Category and Weight
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
                          widget.product.category,
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
                        child: Text(
                          widget.product.weight,
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Rating
                  Row(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(5, (index) {
                          return Icon(
                            index < widget.product.rating.floor()
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 16,
                          );
                        }),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${widget.product.rating.toStringAsFixed(1)} (${widget.product.reviewCount} reviews)',
                        style: AppTypography.body.copyWith(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Product Description
                  Text(
                    'Description',
                    style: AppTypography.h2.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.description,
                    style: AppTypography.body.copyWith(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Quantity Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Quantity',
                        style: AppTypography.h2.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.lightGray,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: widget.product.inStock && quantity > 1
                                  ? () {
                                      setState(() {
                                        quantity--;
                                      });
                                    }
                                  : null,
                              icon: const Icon(Icons.remove),
                              color: widget.product.inStock && quantity > 1
                                  ? AppColors.primaryRed
                                  : AppColors.textGrey,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                '$quantity',
                                style: AppTypography.body.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: widget.product.inStock
                                  ? () {
                                      setState(() {
                                        quantity++;
                                      });
                                    }
                                  : null,
                              icon: const Icon(Icons.add),
                              color: widget.product.inStock
                                  ? AppColors.primaryRed
                                  : AppColors.textGrey,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Price and Add to Cart
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '\$${totalPrice.toStringAsFixed(2)}',
                            style: AppTypography.h1.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryRed,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 160,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: widget.product.inStock
                              ? () {
                                  widget.onAddToCart(quantity);
                                  Navigator.pop(context);
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: widget.product.inStock
                                ? AppColors.primaryRed
                                : AppColors.textGrey,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            widget.product.inStock ? 'Add to Cart' : 'Out of Stock',
                            style: AppTypography.button.copyWith(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Related Products Section
                  Text(
                    'Related Products',
                    style: AppTypography.h2.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 4, // Sample related products
                      itemBuilder: (context, index) {
                        return Container(
                          width: 100,
                          margin: const EdgeInsets.only(right: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 100,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: AppColors.lightGray,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.fastfood,
                                  size: 30,
                                  color: AppColors.primaryRed.withOpacity(0.5),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Related Product ${index + 1}',
                                style: AppTypography.caption.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '\$${(10 + index * 5).toStringAsFixed(2)}',
                                style: AppTypography.caption.copyWith(
                                  fontSize: 12,
                                  color: AppColors.primaryRed,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String category;
  final String description;
  final String weight;
  final bool inStock;
  final double rating;
  final int reviewCount;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.description,
    required this.weight,
    required this.inStock,
    required this.rating,
    required this.reviewCount,
  });
}