import 'package:flutter/material.dart';
import 'package:myapp/core/constants/colors.dart';
import 'package:myapp/core/constants/typography.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  String selectedTab = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.neutralGray.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
            onPressed: () => Navigator.pop(context),
            padding: EdgeInsets.zero,
          ),
        ),
        title: Text(
          'Order History',
          style: AppTypography.h2.copyWith(fontSize: 20),
        ),
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _TabButton(
                  label: 'All',
                  isSelected: selectedTab == 'All',
                  onTap: () {
                    setState(() {
                      selectedTab = 'All';
                    });
                  },
                ),
                SizedBox(width: 12),
                _TabButton(
                  label: 'Ongoing',
                  isSelected: selectedTab == 'Ongoing',
                  onTap: () {
                    setState(() {
                      selectedTab = 'Ongoing';
                    });
                  },
                ),
                SizedBox(width: 12),
                _TabButton(
                  label: 'Delivered',
                  isSelected: selectedTab == 'Delivered',
                  onTap: () {
                    setState(() {
                      selectedTab = 'Delivered';
                    });
                  },
                ),
                SizedBox(width: 12),
                _TabButton(
                  label: 'Cancelled',
                  isSelected: selectedTab == 'Cancelled',
                  onTap: () {
                    setState(() {
                      selectedTab = 'Cancelled';
                    });
                  },
                ),
              ],
            ),
          ),
          
          // Order List
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                _OrderCard(
                  orderId: '#FB12345',
                  date: '26 July 2024',
                  amount: '\$50.00',
                  status: 'Delivered',
                  statusColor: AppColors.freshGreen,
                ),
                SizedBox(height: 12),
                _OrderCard(
                  orderId: '#FB12344',
                  date: '20 July 2024',
                  amount: '\$75.00',
                  status: 'Processing',
                  statusColor: AppColors.neutralGray,
                ),
                SizedBox(height: 12),
                _OrderCard(
                  orderId: '#FB12343',
                  date: '15 July 2024',
                  amount: '\$30.00',
                  status: 'Cancelled',
                  statusColor: AppColors.primaryRed,
                ),
                SizedBox(height: 40),
                
                // Empty State
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.lightGray,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.receipt_long_outlined,
                          size: 50,
                          color: AppColors.neutralGray,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'No past orders yet.',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Your past orders will appear here.',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          // Shop now action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryRed,
                          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Shop Now',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.transparent : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppColors.primaryRed : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColors.primaryRed : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final String orderId;
  final String date;
  final String amount;
  final String status;
  final Color statusColor;

  const _OrderCard({
    required this.orderId,
    required this.date,
    required this.amount,
    required this.status,
    required this.statusColor,
  });

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order ID: $orderId',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    date,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Text(
                status,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            amount,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                // View details action
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryRed,
                side: BorderSide(color: AppColors.primaryRed),
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'View Details',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryRed,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}