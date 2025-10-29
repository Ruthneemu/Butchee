import 'package:flutter/material.dart';
import 'package:myapp/core/constants/colors.dart';
import 'package:myapp/core/constants/typography.dart';
import 'package:myapp/routes/app_routes.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int _selectedIndex = 1;

  final List<CartItem> _cartItems = [
    CartItem(
      name: 'Premium Beef Fillet',
      weight: '2 lbs',
      price: 50.00,
      quantity: 1,
    ),
    CartItem(
      name: 'Organic Chicken Breast',
      weight: '1.5 lbs',
      price: 35.00,
      quantity: 2,
    ),
    CartItem(
      name: 'Fresh Pork Chops',
      weight: '1 lb',
      price: 20.00,
      quantity: 1,
    ),
  ];

  double get subtotal {
    return _cartItems.fold(
        0, (sum, item) => sum + (item.price * item.quantity));
  }

  double get delivery => _cartItems.isEmpty ? 0.00 : 5.00;
  double get total => subtotal + delivery;

  void _removeItem(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Item removed from cart'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            // In a real app, you'd restore the item here
          },
        ),
      ),
    );
  }

  void _updateQuantity(int index, int newQuantity) {
    if (newQuantity < 1) {
      _showRemoveDialog(index);
    } else if (newQuantity > 99) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Maximum quantity is 99'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      setState(() {
        _cartItems[index].quantity = newQuantity;
      });
    }
  }

  void _showRemoveDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Item'),
          content: const Text('Do you want to remove this item from your cart?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _removeItem(index);
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryRed,
              ),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  void _proceedToCheckout() {
    if (_cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Proceed to Checkout'),
          content: Text(
            'Total amount: \$${total.toStringAsFixed(2)}\n\nCheckout functionality would be implemented here.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.checkout);
                // Navigate to checkout page
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                foregroundColor: Colors.white,
              ),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToPage(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Handle navigation based on index
    switch (index) {
      case 0:
        Navigator.of(context).popUntil((route) => route.isFirst);
        break;
      case 1:
        // Already on cart page
        break;
      case 2:
        // Navigate to orders page
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Orders page - to be implemented'),
            duration: Duration(seconds: 2),
          ),
        );
        break;
      case 3:
        // Navigate to account page
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account page - to be implemented'),
            duration: Duration(seconds: 2),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.textPrimary,
          ),
        ),
        title: Text(
          'Cart (${_cartItems.length})',
          style: AppTypography.h2.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: false,
        actions: [
          if (_cartItems.isNotEmpty)
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Clear Cart'),
                      content: const Text('Remove all items from your cart?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _cartItems.clear();
                            });
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primaryRed,
                          ),
                          child: const Text('Clear'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text(
                'Clear',
                style: TextStyle(color: AppColors.primaryRed),
              ),
            ),
        ],
      ),
      body: _cartItems.isEmpty
          ? _buildEmptyCart()
          : Column(
              children: [
                // Cart Items List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _cartItems.length,
                    itemBuilder: (context, index) {
                      final item = _cartItems[index];
                      return Dismissible(
                        key: Key('${item.name}_$index'),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Remove Item'),
                                content: Text('Remove ${item.name} from cart?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    style: TextButton.styleFrom(
                                      foregroundColor: AppColors.primaryRed,
                                    ),
                                    child: const Text('Remove'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        onDismissed: (direction) {
                          setState(() {
                            _cartItems.removeAt(index);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${item.name} removed'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: _buildCartItem(item, index),
                      );
                    },
                  ),
                ),

                // Order Summary
                _buildOrderSummary(),
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigateToPage,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryRed,
        unselectedItemColor: AppColors.textGrey,
        selectedLabelStyle: AppTypography.caption.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTypography.caption.copyWith(
          fontSize: 12,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Account',
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: AppColors.textGrey.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: AppTypography.h2.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add items to get started',
            style: AppTypography.body.copyWith(
              fontSize: 14,
              color: AppColors.textGrey,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Start Shopping'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItem item, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
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
            // Product Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.lightGray.withOpacity(0.3),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: Icon(
                  Icons.fastfood,
                  size: 40,
                  color: AppColors.primaryRed.withOpacity(0.3),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.name,
                    style: AppTypography.body.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.weight,
                    style: AppTypography.caption.copyWith(
                      fontSize: 12,
                      color: AppColors.textGrey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: AppTypography.body.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryRed,
                    ),
                  ),
                ],
              ),
            ),
            // Quantity Controls
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.lightGray.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => _updateQuantity(index, item.quantity - 1),
                    icon: Icon(
                      Icons.remove,
                      size: 16,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    '${item.quantity}',
                    style: AppTypography.body.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primaryRed,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => _updateQuantity(index, item.quantity + 1),
                    icon: const Icon(
                      Icons.add,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: AppTypography.h2.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          // Subtotal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal',
                style: AppTypography.body.copyWith(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '\$${subtotal.toStringAsFixed(2)}',
                style: AppTypography.body.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Delivery
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Delivery',
                style: AppTypography.body.copyWith(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '\$${delivery.toStringAsFixed(2)}',
                style: AppTypography.body.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(
            color: AppColors.neutralGray.withOpacity(0.3),
          ),
          const SizedBox(height: 12),
          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: AppTypography.h2.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: AppTypography.h1.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryRed,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Proceed to Checkout Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _proceedToCheckout,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Text(
                'Proceed to Checkout',
                style: AppTypography.button.copyWith(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CartItem {
  final String name;
  final String weight;
  final double price;
  int quantity;

  CartItem({
    required this.name,
    required this.weight,
    required this.price,
    required this.quantity,
  });
}