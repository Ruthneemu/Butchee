import 'package:flutter/material.dart';
import 'package:myapp/core/constants/colors.dart';
import 'package:myapp/core/constants/typography.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({super.key});

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
          'Order Details',
          style: AppTypography.h2.copyWith(fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.download_outlined, color: AppColors.textSecondary),
            onPressed: () {
              // Download action
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Header Card
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order ID #ORD12345',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'July 26, 2024',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.freshGreen,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Delivered',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),

                // Order Items
                _OrderItem(
                  image: 'assets/beef.jpg', // Placeholder
                  name: 'Premium Beef Tenderloin',
                  quantity: 2,
                  price: 60.00,
                ),
                SizedBox(height: 12),
                _OrderItem(
                  image: 'assets/chicken.jpg', // Placeholder
                  name: 'Organic Chicken Breast',
                  quantity: 1,
                  price: 15.00,
                ),
                SizedBox(height: 12),
                _OrderItem(
                  image: 'assets/salmon.jpg', // Placeholder
                  name: 'Fresh Salmon Fillet',
                  quantity: 3,
                  price: 45.00,
                ),
                SizedBox(height: 16),

                // Delivery Information
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Delivery Information',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 12),
                      _InfoRow(
                        label: 'Address:',
                        value: '123 Main St, Anytown, USA',
                      ),
                      SizedBox(height: 8),
                      _InfoRow(
                        label: 'Delivery Type:',
                        value: 'Standard',
                      ),
                      SizedBox(height: 8),
                      _InfoRow(
                        label: 'Contact:',
                        value: '(555) 123-4567',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),

                // Payment Summary
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment Summary',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 12),
                      _PaymentRow(
                        label: 'Subtotal',
                        value: '\$120.00',
                        isRegular: true,
                      ),
                      SizedBox(height: 8),
                      _PaymentRow(
                        label: 'Tax (8%)',
                        value: '\$9.60',
                        isRegular: true,
                      ),
                      SizedBox(height: 8),
                      _PaymentRow(
                        label: 'Delivery',
                        value: '\$5.00',
                        isRegular: true,
                      ),
                      SizedBox(height: 12),
                      Divider(color: AppColors.neutralGray),
                      SizedBox(height: 12),
                      _PaymentRow(
                        label: 'Total',
                        value: '\$134.60',
                        isRegular: false,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 80), // Space for FAB
              ],
            ),
          ),
          
          // Floating Chat Button
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                // Chat action
              },
              backgroundColor: AppColors.primaryRed,
              child: Icon(Icons.chat_bubble_outline, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderItem extends StatelessWidget {
  final String image;
  final String name;
  final int quantity;
  final double price;

  const _OrderItem({
    required this.image,
    required this.name,
    required this.quantity,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
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
              Icons.image_outlined,
              color: AppColors.neutralGray,
              size: 30,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Qty: $quantity',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '\$${price.toStringAsFixed(2)}',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

class _PaymentRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isRegular;

  const _PaymentRow({
    required this.label,
    required this.value,
    required this.isRegular,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: isRegular ? 'Inter' : 'Poppins',
            fontSize: isRegular ? 14 : 16,
            fontWeight: isRegular ? FontWeight.normal : FontWeight.w600,
            color: isRegular ? AppColors.textSecondary : AppColors.textPrimary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: isRegular ? 14 : 18,
            fontWeight: FontWeight.w600,
            color: isRegular ? AppColors.textPrimary : AppColors.primaryRed,
          ),
        ),
      ],
    );
  }
}