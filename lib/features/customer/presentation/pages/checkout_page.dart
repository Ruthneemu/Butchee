import 'package:flutter/material.dart';
import 'package:myapp/core/constants/colors.dart';
import 'package:myapp/core/constants/typography.dart';
import 'package:myapp/routes/app_routes.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String selectedPaymentMethod = 'Cash on Delivery';
  String selectedAddress = '123 Main Street, Nairobi';
  String selectedDeliveryTime = 'Standard (1-2 days)';
  bool isProcessing = false;
  
  final TextEditingController _promoController = TextEditingController();
  double _discountAmount = 0.0;
  String? _appliedPromoCode;

  final List<String> _savedAddresses = [
    '123 Main Street, Nairobi',
    '456 Oak Avenue, Nairobi',
    '789 Palm Road, Mombasa',
  ];

  final List<String> _deliveryTimes = [
    'Standard (1-2 days)',
    'Express (Same day)',
    'Scheduled delivery',
  ];

  final List<OrderItem> _orderItems = [
    OrderItem(
      name: 'Premium Beef Cuts',
      quantity: 2,
      price: 30.00,
      weight: '2 lbs',
    ),
    OrderItem(
      name: 'Fresh Chicken',
      quantity: 1,
      price: 15.00,
      weight: '1.5 lbs',
    ),
  ];

  double get _subtotal =>
      _orderItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

  double get _deliveryFee {
    if (selectedDeliveryTime.contains('Express')) {
      return 10.00;
    }
    return 5.00;
  }

  double get _total => _subtotal + _deliveryFee - _discountAmount;

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  void _changeAddress() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.neutralGray.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Select Delivery Address',
              style: AppTypography.h2.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ..._savedAddresses.map((address) => _buildAddressOption(address)),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.checkoutAddress);
                _addNewAddress();
              },
              icon: const Icon(Icons.add),
              label: const Text('Add New Address'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryRed,
                side: BorderSide(color: AppColors.primaryRed),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressOption(String address) {
    final isSelected = address == selectedAddress;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAddress = address;
        });
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryRed.withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryRed : AppColors.neutralGray,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.location_on,
              color: isSelected ? AppColors.primaryRed : AppColors.textGrey,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                address,
                style: AppTypography.body.copyWith(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.primaryRed,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  void _addNewAddress() {
    final TextEditingController addressController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Address'),
        content: TextField(
          controller: addressController,
          decoration: InputDecoration(
            hintText: 'Enter your address',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          maxLines: 2,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (addressController.text.trim().isNotEmpty) {
                setState(() {
                  _savedAddresses.add(addressController.text.trim());
                  selectedAddress = addressController.text.trim();
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Address added successfully'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              foregroundColor: Colors.white,
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _applyPromoCode() {
    final code = _promoController.text.trim().toUpperCase();
    
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a promo code'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Simulate promo code validation
    final Map<String, double> validCodes = {
      'SAVE10': 0.10,
      'WELCOME20': 0.20,
      'FLAT5': 5.00,
    };

    if (validCodes.containsKey(code)) {
      setState(() {
        if (code == 'FLAT5') {
          _discountAmount = validCodes[code]!;
        } else {
          _discountAmount = _subtotal * validCodes[code]!;
        }
        _appliedPromoCode = code;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Promo code applied! You saved \$${_discountAmount.toStringAsFixed(2)}'),
          duration: const Duration(seconds: 3),
          backgroundColor: AppColors.freshGreen,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid promo code'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _removePromoCode() {
    setState(() {
      _discountAmount = 0.0;
      _appliedPromoCode = null;
      _promoController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Promo code removed'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _updateItemQuantity(int index, int newQuantity) {
    if (newQuantity < 1) {
      _showRemoveItemDialog(index);
    } else if (newQuantity > 50) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Maximum quantity is 50'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      setState(() {
        _orderItems[index].quantity = newQuantity;
      });
    }
  }

  void _showRemoveItemDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Item'),
        content: Text('Remove ${_orderItems[index].name} from your order?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _orderItems.removeAt(index);
              });
              Navigator.pop(context);
              
              if (_orderItems.isEmpty) {
                Navigator.pop(context);
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primaryRed,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _selectDeliveryTime() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.neutralGray.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Select Delivery Time',
              style: AppTypography.h2.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ..._deliveryTimes.map((time) => _buildDeliveryTimeOption(time)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryTimeOption(String time) {
    final isSelected = time == selectedDeliveryTime;
    String fee = '\$5.00';
    if (time.contains('Express')) {
      fee = '\$10.00';
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDeliveryTime = time;
        });
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryRed.withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryRed : AppColors.neutralGray,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.local_shipping,
              color: isSelected ? AppColors.primaryRed : AppColors.textGrey,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    time,
                    style: AppTypography.body.copyWith(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'Delivery fee: $fee',
                    style: AppTypography.caption.copyWith(
                      fontSize: 12,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.primaryRed,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  void _placeOrder() {
    if (_orderItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Validate payment method specific requirements
    if (selectedPaymentMethod == 'M-Pesa') {
      _showMpesaDialog();
      return;
    } else if (selectedPaymentMethod == 'Card Payment') {
      _showCardPaymentDialog();
      return;
    }

    // Process Cash on Delivery
    _processOrder();
  }

  void _showMpesaDialog() {
    final TextEditingController phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('M-Pesa Payment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Amount: \$${_total.toStringAsFixed(2)}',
              style: AppTypography.body.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryRed,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'M-Pesa Phone Number',
                hintText: '254...',
                prefixIcon: const Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'You will receive a prompt on your phone',
              style: AppTypography.caption.copyWith(
                fontSize: 12,
                color: AppColors.textGrey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (phoneController.text.trim().isNotEmpty) {
                Navigator.pop(context);
                _processOrder();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              foregroundColor: Colors.white,
            ),
            child: const Text('Send Prompt'),
          ),
        ],
      ),
    );
  }

  void _showCardPaymentDialog() {
    final TextEditingController cardNumberController = TextEditingController();
    final TextEditingController expiryController = TextEditingController();
    final TextEditingController cvvController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Card Payment'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Amount: \$${_total.toStringAsFixed(2)}',
                style: AppTypography.body.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryRed,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: cardNumberController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Card Number',
                  hintText: '1234 5678 9012 3456',
                  prefixIcon: const Icon(Icons.credit_card),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: expiryController,
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        labelText: 'Expiry',
                        hintText: 'MM/YY',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: cvvController,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'CVV',
                        hintText: '123',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (cardNumberController.text.trim().isNotEmpty &&
                  expiryController.text.trim().isNotEmpty &&
                  cvvController.text.trim().isNotEmpty) {
                Navigator.pop(context);
                _processOrder();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              foregroundColor: Colors.white,
            ),
            child: const Text('Pay Now'),
          ),
        ],
      ),
    );
  }

  void _processOrder() {
    setState(() {
      isProcessing = true;
    });

    // Simulate order processing
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      setState(() {
        isProcessing = false;
      });

      _showOrderSuccessDialog();
    });
  }

  void _showOrderSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.freshGreen.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                color: AppColors.freshGreen,
                size: 60,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Order Placed Successfully!',
              style: AppTypography.h2.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Your order #${DateTime.now().millisecondsSinceEpoch.toString().substring(7)} has been confirmed',
              style: AppTypography.body.copyWith(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.lightGray.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    'Total Paid',
                    style: AppTypography.caption.copyWith(
                      fontSize: 12,
                      color: AppColors.textGrey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${_total.toStringAsFixed(2)}',
                    style: AppTypography.h1.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryRed,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back to previous page
            },
            child: const Text('View Orders'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              foregroundColor: Colors.white,
            ),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Checkout',
          style: AppTypography.h2.copyWith(fontSize: 20),
        ),
      ),
      body: _orderItems.isEmpty
          ? _buildEmptyCart()
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Delivery Address Section
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Delivery Address',
                                    style: AppTypography.caption.copyWith(
                                      fontSize: 14,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: _changeAddress,
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: const Size(0, 0),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Text(
                                      'Change',
                                      style: AppTypography.button.copyWith(
                                        fontSize: 14,
                                        color: AppColors.primaryRed,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 20,
                                    color: AppColors.primaryRed,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      selectedAddress,
                                      style: AppTypography.body.copyWith(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Delivery Time Section
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: AppColors.primaryRed,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Delivery Time',
                                      style: AppTypography.caption.copyWith(
                                        fontSize: 12,
                                        color: AppColors.textGrey,
                                      ),
                                    ),
                                    Text(
                                      selectedDeliveryTime,
                                      style: AppTypography.body.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: _selectDeliveryTime,
                                child: Text(
                                  'Change',
                                  style: TextStyle(color: AppColors.primaryRed),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Order Summary Section
                        Text(
                          'Order Summary',
                          style: AppTypography.h2.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Order Items
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              ..._orderItems.asMap().entries.map((entry) {
                                int index = entry.key;
                                OrderItem item = entry.value;
                                return Column(
                                  children: [
                                    if (index > 0)
                                      Divider(
                                        height: 1,
                                        color: AppColors.lightGray,
                                      ),
                                    _OrderItemWidget(
                                      item: item,
                                      onQuantityChanged: (newQuantity) =>
                                          _updateItemQuantity(
                                              index, newQuantity),
                                    ),
                                  ],
                                );
                              }).toList(),

                              // Promo Code Section
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.lightGray.withOpacity(0.3),
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    if (_appliedPromoCode == null)
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller: _promoController,
                                              decoration: InputDecoration(
                                                hintText: 'Enter promo code',
                                                hintStyle:
                                                    AppTypography.caption.copyWith(
                                                  fontSize: 13,
                                                  color: AppColors.textGrey,
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  borderSide: BorderSide(
                                                    color: AppColors.neutralGray,
                                                  ),
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 12,
                                                ),
                                                filled: true,
                                                fillColor: Colors.white,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          ElevatedButton(
                                            onPressed: _applyPromoCode,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.primaryRed,
                                              foregroundColor: Colors.white,
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 20,
                                                vertical: 12,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: const Text('Apply'),
                                          ),
                                        ],
                                      )
                                    else
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: AppColors.freshGreen.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: AppColors.freshGreen,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.local_offer,
                                              color: AppColors.freshGreen,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Promo "$_appliedPromoCode" applied',
                                                    style: AppTypography.body
                                                        .copyWith(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          AppColors.freshGreen,
                                                    ),
                                                  ),
                                                  Text(
                                                    'You saved \${_discountAmount.toStringAsFixed(2)}',
                                                    style: AppTypography
                                                        .caption
                                                        .copyWith(
                                                      fontSize: 11,
                                                      color:
                                                          AppColors.freshGreen,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: _removePromoCode,
                                              icon: Icon(
                                                Icons.close,
                                                size: 18,
                                                color: AppColors.freshGreen,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    const SizedBox(height: 16),

                                    // Summary Rows
                                    _SummaryRow(
                                      label: 'Subtotal',
                                      value: '\${_subtotal.toStringAsFixed(2)}',
                                      isRegular: true,
                                    ),
                                    const SizedBox(height: 8),
                                    _SummaryRow(
                                      label: 'Delivery Fee',
                                      value:
                                          '\${_deliveryFee.toStringAsFixed(2)}',
                                      isRegular: true,
                                    ),
                                    if (_discountAmount > 0) ...[
                                      const SizedBox(height: 8),
                                      _SummaryRow(
                                        label: 'Discount',
                                        value:
                                            '-\${_discountAmount.toStringAsFixed(2)}',
                                        isRegular: true,
                                        valueColor: AppColors.freshGreen,
                                      ),
                                    ],
                                    const SizedBox(height: 12),
                                    Divider(color: AppColors.neutralGray),
                                    const SizedBox(height: 12),
                                    _SummaryRow(
                                      label: 'Total',
                                      value: '\${_total.toStringAsFixed(2)}',
                                      isRegular: false,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Payment Method Section
                        Text(
                          'Payment Method',
                          style: AppTypography.h2.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Payment Options
                        _PaymentOption(
                          label: 'Cash on Delivery',
                          subtitle: 'Pay when you receive',
                          icon: Icons.money,
                          value: 'Cash on Delivery',
                          groupValue: selectedPaymentMethod,
                          onChanged: (value) {
                            setState(() {
                              selectedPaymentMethod = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 8),
                        _PaymentOption(
                          label: 'M-Pesa',
                          subtitle: 'Mobile money payment',
                          icon: Icons.phone_android,
                          value: 'M-Pesa',
                          groupValue: selectedPaymentMethod,
                          onChanged: (value) {
                            setState(() {
                              selectedPaymentMethod = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 8),
                        _PaymentOption(
                          label: 'Card Payment',
                          subtitle: 'Credit or Debit card',
                          icon: Icons.credit_card,
                          value: 'Card Payment',
                          groupValue: selectedPaymentMethod,
                          onChanged: (value) {
                            setState(() {
                              selectedPaymentMethod = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 20),

                        // Order Notes
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.note_alt_outlined,
                                    size: 20,
                                    color: AppColors.textGrey,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Order Notes (Optional)',
                                    style: AppTypography.body.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                maxLines: 3,
                                decoration: InputDecoration(
                                  hintText:
                                      'Add any special instructions for your order...',
                                  hintStyle: AppTypography.caption.copyWith(
                                    fontSize: 13,
                                    color: AppColors.textGrey,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: AppColors.neutralGray,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.all(12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Place Order Button
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Amount',
                                  style: AppTypography.caption.copyWith(
                                    fontSize: 12,
                                    color: AppColors.textGrey,
                                  ),
                                ),
                                Text(
                                  '\${_total.toStringAsFixed(2)}',
                                  style: AppTypography.h1.copyWith(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryRed,
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: SizedBox(
                                  height: 56,
                                  child: ElevatedButton(
                                    onPressed: isProcessing ? null : _placeOrder,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primaryRed,
                                      disabledBackgroundColor:
                                          AppColors.textGrey,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: isProcessing
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : Text(
                                            'Place Order',
                                            style: AppTypography.button,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
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
            'Add items to checkout',
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
}

class OrderItem {
  final String name;
  int quantity;
  final double price;
  final String weight;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
    required this.weight,
  });
}

class _OrderItemWidget extends StatelessWidget {
  final OrderItem item;
  final Function(int) onQuantityChanged;

  const _OrderItemWidget({
    required this.item,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.lightGray,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.fastfood,
              color: AppColors.primaryRed.withOpacity(0.3),
              size: 30,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: AppTypography.body.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
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
                  '\${item.price.toStringAsFixed(2)} each',
                  style: AppTypography.caption.copyWith(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\${(item.price * item.quantity).toStringAsFixed(2)}',
                style: AppTypography.body.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryRed,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.neutralGray.withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () => onQuantityChanged(item.quantity - 1),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          Icons.remove,
                          size: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        '${item.quantity}',
                        style: AppTypography.body.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => onQuantityChanged(item.quantity + 1),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          Icons.add,
                          size: 16,
                          color: AppColors.primaryRed,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isRegular;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.isRegular,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.body.copyWith(
            fontSize: isRegular ? 14 : 16,
            fontWeight: isRegular ? FontWeight.normal : FontWeight.w600,
            color: isRegular ? AppColors.textSecondary : AppColors.textPrimary,
          ),
        ),
        Text(
          value,
          style: AppTypography.body.copyWith(
            fontSize: isRegular ? 14 : 18,
            fontWeight: FontWeight.w600,
            color: valueColor ??
                (isRegular ? AppColors.textPrimary : AppColors.primaryRed),
          ),
        ),
      ],
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final String value;
  final String groupValue;
  final ValueChanged<String?> onChanged;

  const _PaymentOption({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.primaryRed : AppColors.neutralGray,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: RadioListTile<String>(
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryRed.withOpacity(0.1)
                    : AppColors.lightGray.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 20,
                color: isSelected ? AppColors.primaryRed : AppColors.textGrey,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTypography.body.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTypography.caption.copyWith(
                      fontSize: 12,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        activeColor: AppColors.primaryRed,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        dense: true,
      ),
    );
  }
}