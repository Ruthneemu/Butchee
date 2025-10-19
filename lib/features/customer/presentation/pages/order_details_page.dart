import 'package:flutter/material.dart';
import 'package:myapp/core/constants/colors.dart';
import 'package:myapp/core/constants/typography.dart';
import 'package:myapp/routes/app_routes.dart';

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({super.key});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  int _selectedIndex = 2; // Orders tab selected by default

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          },
        ),
        title: Text(
          'Order Details',
          style: AppTypography.h2.copyWith(fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.download_outlined, color: AppColors.textSecondary),
            onPressed: () {
              // TODO: Implement download invoice action
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─────────────── Order Header ───────────────
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
                      Text('Order ID #ORD12345',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          )),
                      SizedBox(height: 4),
                      Text('July 26, 2024',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          )),
                    ],
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

            // ─────────────── Order Items ───────────────
            _OrderItem(
              image: 'assets/beef.jpg',
              name: 'Premium Beef Tenderloin',
              quantity: 2,
              price: 60.00,
            ),
            SizedBox(height: 12),
            _OrderItem(
              image: 'assets/chicken.jpg',
              name: 'Organic Chicken Breast',
              quantity: 1,
              price: 15.00,
            ),
            SizedBox(height: 12),
            _OrderItem(
              image: 'assets/salmon.jpg',
              name: 'Fresh Salmon Fillet',
              quantity: 3,
              price: 45.00,
            ),
            SizedBox(height: 16),

            // ─────────────── Delivery Information ───────────────
            _InfoCard(
              title: 'Delivery Information',
              children: const [
                _InfoRow(label: 'Address:', value: '123 Main St, Anytown, USA'),
                SizedBox(height: 8),
                _InfoRow(label: 'Delivery Type:', value: 'Standard'),
                SizedBox(height: 8),
                _InfoRow(label: 'Contact:', value: '(555) 123-4567'),
              ],
            ),
            SizedBox(height: 16),

            // ─────────────── Payment Summary ───────────────
            _InfoCard(
              title: 'Payment Summary',
              children: const [
                _PaymentRow(label: 'Subtotal', value: '\$120.00', isRegular: true),
                SizedBox(height: 8),
                _PaymentRow(label: 'Tax (8%)', value: '\$9.60', isRegular: true),
                SizedBox(height: 8),
                _PaymentRow(label: 'Delivery', value: '\$5.00', isRegular: true),
                SizedBox(height: 12),
                Divider(),
                SizedBox(height: 12),
                _PaymentRow(label: 'Total', value: '\$134.60', isRegular: false),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),

      // ─────────────── Floating Action Button ───────────────
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement chat support
        },
        backgroundColor: AppColors.primaryRed,
        child: Icon(Icons.chat_bubble_outline, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      // ─────────────── Bottom Navigation ───────────────
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          // If the same tab is tapped, do nothing
          if (index == _selectedIndex) return;

          setState(() {
            _selectedIndex = index;
          });

          // 🧭 Handle page navigation
          switch (index) {
            case 0:
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.home,
                (route) => false,
              );
              break;
            case 1:
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.products,
                (route) => false,
              );
              break;
            case 2:
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.orderHistory,
                (route) => false,
              );
              break;
            case 3:
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.profile,
                (route) => false,
              );
              break;
          }
        },
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
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Shop',
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
}

// ───────────────────────────── Helper Widgets ─────────────────────────────

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
            child: Icon(Icons.image_outlined,
                color: AppColors.neutralGray, size: 30),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    )),
                SizedBox(height: 4),
                Text('Qty: $quantity',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    )),
              ],
            ),
          ),
          Text('\$${price.toStringAsFixed(2)}',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              )),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _InfoCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Text(title,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              )),
          SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label ',
            style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary)),
        Expanded(
          child: Text(value,
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: AppColors.textSecondary)),
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
          Text(label,
              style: TextStyle(
                fontFamily: isRegular ? 'Inter' : 'Poppins',
                fontSize: isRegular ? 14 : 16,
                fontWeight:
                    isRegular ? FontWeight.normal : FontWeight.w600,
                color:
                    isRegular ? AppColors.textSecondary : AppColors.textPrimary,
              )),
          Text(value,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: isRegular ? 14 : 18,
                fontWeight: FontWeight.w600,
                color: isRegular
                    ? AppColors.textPrimary
                    : AppColors.primaryRed,
              )),
        ]);
  }
}