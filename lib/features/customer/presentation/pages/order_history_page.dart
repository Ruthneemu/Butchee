import 'package:flutter/material.dart';
import 'package:myapp/core/constants/colors.dart';
import 'package:myapp/core/constants/typography.dart';
import 'package:myapp/routes/app_routes.dart';
import 'package:intl/intl.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  String selectedTab = 'All';
  String searchQuery = '';
  DateTime? startDate;
  DateTime? endDate;
  bool isRefreshing = false;

  // Sample order data with enhanced details
  final List<OrderItem> orders = [
    OrderItem(
      orderId: '#FB12345',
      date: DateTime(2024, 7, 26),
      amount: 50.00,
      status: 'Delivered',
      statusColor: AppColors.freshGreen,
      deliveryMethod: 'Home Delivery',
      deliveryAddress: '123 Main St, New York, NY',
      paymentMethod: 'M-Pesa',
      itemsCount: 3,
      expectedDelivery: DateTime(2024, 7, 28),
      trackingNumber: 'TRK123456789',
      orderNotes: 'Leave at the gate',
      items: [
        OrderItemDetail(name: 'Burger Meal', quantity: 1, price: 15.00),
        OrderItemDetail(name: 'Pizza', quantity: 1, price: 20.00),
        OrderItemDetail(name: 'Soda', quantity: 1, price: 5.00),
      ],
    ),
    OrderItem(
      orderId: '#FB12344',
      date: DateTime(2024, 7, 20),
      amount: 75.00,
      status: 'Out for Delivery',
      statusColor: Colors.orange,
      deliveryMethod: 'Express Delivery',
      deliveryAddress: '456 Park Ave, New York, NY',
      paymentMethod: 'Credit Card',
      itemsCount: 2,
      expectedDelivery: DateTime(2024, 7, 21),
      trackingNumber: 'TRK987654321',
      orderNotes: 'Call upon arrival',
      items: [
        OrderItemDetail(name: 'Chicken Wings', quantity: 1, price: 25.00),
        OrderItemDetail(name: 'Salad', quantity: 1, price: 10.00),
      ],
    ),
    OrderItem(
      orderId: '#FB12343',
      date: DateTime(2024, 7, 15),
      amount: 30.00,
      status: 'Cancelled',
      statusColor: AppColors.primaryRed,
      deliveryMethod: 'Pick-up at Store',
      deliveryAddress: '789 Broadway, New York, NY',
      paymentMethod: 'Cash on Delivery',
      itemsCount: 1,
      expectedDelivery: DateTime(2024, 7, 16),
      trackingNumber: '',
      orderNotes: '',
      items: [
        OrderItemDetail(name: 'Sandwich', quantity: 1, price: 10.00),
      ],
    ),
  ];

  // Filter orders based on selected tab and search query
  List<OrderItem> get filteredOrders {
    List<OrderItem> result = orders;

    // Apply tab filter
    if (selectedTab != 'All') {
      if (selectedTab == 'Ongoing') {
        result = result.where((order) => 
          order.status == 'Processing' || 
          order.status == 'Out for Delivery'
        ).toList();
      } else {
        result = result.where((order) => order.status == selectedTab).toList();
      }
    }

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      result = result.where((order) => 
        order.orderId.toLowerCase().contains(searchQuery.toLowerCase()) ||
        order.date.toString().contains(searchQuery)
      ).toList();
    }

    // Apply date range filter
    if (startDate != null && endDate != null) {
      result = result.where((order) => 
        order.date.isAfter(startDate!) && order.date.isBefore(endDate!)
      ).toList();
    }

    return result;
  }

  // Refresh orders
  Future<void> _refreshOrders() async {
    setState(() {
      isRefreshing = true;
    });
    
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      isRefreshing = false;
    });
  }

  // Show date range picker
  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    
    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
      });
    }
  }

  // Clear date filter
  void _clearDateFilter() {
    setState(() {
      startDate = null;
      endDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.neutralGray.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.home);
            },
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
          // Search and Filter Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.lightGray,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search by order ID or date',
                      hintStyle: TextStyle(color: AppColors.textSecondary),
                      prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                
                // Date Filter
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: _selectDateRange,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.lightGray,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today, color: AppColors.textSecondary, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  startDate != null && endDate != null
                                      ? '${DateFormat('MMM dd').format(startDate!)} - ${DateFormat('MMM dd, yyyy').format(endDate!)}'
                                      : 'Filter by date',
                                  style: TextStyle(
                                    color: startDate != null ? AppColors.textPrimary : AppColors.textSecondary,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              if (startDate != null)
                                InkWell(
                                  onTap: _clearDateFilter,
                                  child: Icon(Icons.clear, color: AppColors.textSecondary, size: 18),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryRed.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.download, color: AppColors.primaryRed, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            'Export',
                            style: TextStyle(
                              color: AppColors.primaryRed,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Tab Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                const SizedBox(width: 12),
                _TabButton(
                  label: 'Ongoing',
                  isSelected: selectedTab == 'Ongoing',
                  onTap: () {
                    setState(() {
                      selectedTab = 'Ongoing';
                    });
                  },
                ),
                const SizedBox(width: 12),
                _TabButton(
                  label: 'Delivered',
                  isSelected: selectedTab == 'Delivered',
                  onTap: () {
                    setState(() {
                      selectedTab = 'Delivered';
                    });
                  },
                ),
                const SizedBox(width: 12),
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
            child: RefreshIndicator(
              onRefresh: _refreshOrders,
              child: filteredOrders.isEmpty
                  ? _buildEmptyState()
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: filteredOrders.map((order) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _OrderCard(
                            order: order,
                            onViewDetails: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrderDetailPage(order: order),
                                ),
                              );
                            },
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
          const SizedBox(height: 20),
          Text(
            searchQuery.isNotEmpty || (startDate != null && endDate != null)
                ? 'No orders found'
                : 'No past orders yet.',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            searchQuery.isNotEmpty || (startDate != null && endDate != null)
                ? 'Try adjusting your search or filters'
                : 'Your past orders will appear here.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: AppColors.textSecondary,
            ),
          ),
          if (searchQuery.isEmpty && startDate == null && endDate == null)
            Column(
              children: [
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.home);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
  final OrderItem order;
  final VoidCallback onViewDetails;

  const _OrderCard({
    required this.order,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order ID: ${order.orderId}',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('MMM dd, yyyy').format(order.date),
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: order.statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  order.status,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: order.statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '\$${order.amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          
          // Additional order details
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  order.deliveryAddress,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          Row(
            children: [
              Icon(Icons.local_shipping_outlined, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                order.deliveryMethod,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.payment_outlined, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                order.paymentMethod,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          if (order.expectedDelivery != null)
            Row(
              children: [
                Icon(Icons.event_outlined, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  'Expected: ${DateFormat('MMM dd, yyyy').format(order.expectedDelivery!)}',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          
          const SizedBox(height: 16),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onViewDetails,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryRed,
                    side: BorderSide(color: AppColors.primaryRed),
                    padding: const EdgeInsets.symmetric(vertical: 12),
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
              if (order.status == 'Out for Delivery' && order.trackingNumber.isNotEmpty) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Open tracking
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Tracking order ${order.trackingNumber}')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryRed,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Track Order',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

// Order Detail Page
class OrderDetailPage extends StatefulWidget {
  final OrderItem order;

  const OrderDetailPage({super.key, required this.order});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.neutralGray.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
            onPressed: () {
              Navigator.pop(context);
            },
            padding: EdgeInsets.zero,
          ),
        ),
        title: Text(
          'Order Details',
          style: AppTypography.h2.copyWith(fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.download_outlined, color: AppColors.primaryRed),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Downloading invoice...')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Status Card
            Container(
              width: double.infinity,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Order ${widget.order.orderId}',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: widget.order.statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          widget.order.status,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: widget.order.statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Order Progress Tracker
                  _OrderProgressTracker(status: widget.order.status),
                  
                  const SizedBox(height: 16),
                  
                  // Order Date and Amount
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Placed on ${DateFormat('MMM dd, yyyy').format(widget.order.date)}',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        '\$${widget.order.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Order Items
            Container(
              width: double.infinity,
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
                  Text(
                    'Order Items',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Item List
                  ...widget.order.items.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.lightGray,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.fastfood,
                              size: 24,
                              color: AppColors.primaryRed.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Qty: ${item.quantity}',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '\$${item.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  
                  const Divider(height: 24),
                  
                  // Order Summary
                  _buildSummaryRow('Subtotal', widget.order.amount),
                  _buildSummaryRow('Delivery Fee', 5.00),
                  _buildSummaryRow('Tax', 2.50),
                  const Divider(height: 16),
                  _buildSummaryRow('Total', widget.order.amount + 5.00 + 2.50, isTotal: true),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Delivery Information
            Container(
              width: double.infinity,
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
                  Text(
                    'Delivery Information',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.order.deliveryAddress,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  Row(
                    children: [
                      Icon(Icons.local_shipping_outlined, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 8),
                      Text(
                        widget.order.deliveryMethod,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  if (widget.order.expectedDelivery != null)
                    Row(
                      children: [
                        Icon(Icons.event_outlined, size: 16, color: AppColors.textSecondary),
                        const SizedBox(width: 8),
                        Text(
                          'Expected: ${DateFormat('MMM dd, yyyy').format(widget.order.expectedDelivery!)}',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  
                  if (widget.order.orderNotes.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.note_outlined, size: 16, color: AppColors.textSecondary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Note: ${widget.order.orderNotes}',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Payment Information
            Container(
              width: double.infinity,
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
                  Text(
                    'Payment Information',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  Row(
                    children: [
                      Icon(Icons.payment_outlined, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 8),
                      Text(
                        'Paid via ${widget.order.paymentMethod}',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  Row(
                    children: [
                      Icon(Icons.check_circle_outline, size: 16, color: AppColors.freshGreen),
                      const SizedBox(width: 8),
                      Text(
                        'Payment Successful',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: AppColors.freshGreen,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Action Buttons
            if (widget.order.status == 'Delivered') ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Contacting support...')),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryRed,
                        side: BorderSide(color: AppColors.primaryRed),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Need Help?',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryRed,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Reordering items...')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryRed,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Reorder',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ] else if (widget.order.status == 'Cancelled') ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Contacting support...')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Contact Support',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

// Order Progress Tracker Widget
class _OrderProgressTracker extends StatelessWidget {
  final String status;

  const _OrderProgressTracker({required this.status});

  @override
  Widget build(BuildContext context) {
    // Determine the current step based on status
    int currentStep = 0;
    if (status == 'Processing') {
      currentStep = 1;
    } else if (status == 'Out for Delivery') {
      currentStep = 2;
    } else if (status == 'Delivered') {
      currentStep = 3;
    }

    return Column(
      children: [
        Row(
          children: [
            _buildProgressStep(
              title: 'Ordered',
              isActive: currentStep >= 0,
              isCompleted: currentStep > 0,
            ),
            _buildProgressLine(isCompleted: currentStep > 0),
            _buildProgressStep(
              title: 'Processing',
              isActive: currentStep >= 1,
              isCompleted: currentStep > 1,
            ),
            _buildProgressLine(isCompleted: currentStep > 1),
            _buildProgressStep(
              title: 'Out for Delivery',
              isActive: currentStep >= 2,
              isCompleted: currentStep > 2,
            ),
            _buildProgressLine(isCompleted: currentStep > 2),
            _buildProgressStep(
              title: 'Delivered',
              isActive: currentStep >= 3,
              isCompleted: currentStep > 3,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressStep({
    required String title,
    required bool isActive,
    required bool isCompleted,
  }) {
    return Expanded(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: isCompleted ? AppColors.freshGreen : (isActive ? AppColors.primaryRed : AppColors.lightGray),
                  shape: BoxShape.circle,
                ),
                child: isCompleted
                    ? Icon(Icons.check, color: Colors.white, size: 12)
                    : null,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressLine({required bool isCompleted}) {
    return Container(
      width: 20,
      height: 2,
      color: isCompleted ? AppColors.freshGreen : AppColors.lightGray,
    );
  }
}

// Data Models
class OrderItem {
  final String orderId;
  final DateTime date;
  final double amount;
  final String status;
  final Color statusColor;
  final String deliveryMethod;
  final String deliveryAddress;
  final String paymentMethod;
  final int itemsCount;
  final DateTime? expectedDelivery;
  final String trackingNumber;
  final String orderNotes;
  final List<OrderItemDetail> items;

  OrderItem({
    required this.orderId,
    required this.date,
    required this.amount,
    required this.status,
    required this.statusColor,
    required this.deliveryMethod,
    required this.deliveryAddress,
    required this.paymentMethod,
    required this.itemsCount,
    required this.expectedDelivery,
    required this.trackingNumber,
    required this.orderNotes,
    required this.items,
  });
}

class OrderItemDetail {
  final String name;
  final int quantity;
  final double price;

  OrderItemDetail({
    required this.name,
    required this.quantity,
    required this.price,
  });
}