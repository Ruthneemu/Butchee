import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final String userId;
  final List<OrderItemModel> items;
  final double subtotal;
  final double tax;
  final double deliveryFee;
  final double total;
  final String status;
  final String deliveryAddress;
  final String contactNumber;
  final DateTime orderDate;
  final DateTime? deliveryDate;
  final String paymentMethod;
  final String? notes;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.deliveryFee,
    required this.total,
    required this.status,
    required this.deliveryAddress,
    required this.contactNumber,
    required this.orderDate,
    this.deliveryDate,
    required this.paymentMethod,
    this.notes,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    List<OrderItemModel> items = [];
    if (json['items'] != null) {
      items = (json['items'] as List)
          .map((item) => OrderItemModel.fromJson(item))
          .toList();
    }

    return OrderModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      items: items,
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      tax: (json['tax'] ?? 0).toDouble(),
      deliveryFee: (json['deliveryFee'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending',
      deliveryAddress: json['deliveryAddress'] ?? '',
      contactNumber: json['contactNumber'] ?? '',
      orderDate: json['orderDate'] != null 
          ? (json['orderDate'] is Timestamp 
              ? (json['orderDate'] as Timestamp).toDate() 
              : DateTime.parse(json['orderDate']))
          : DateTime.now(),
      deliveryDate: json['deliveryDate'] != null 
          ? (json['deliveryDate'] is Timestamp 
              ? (json['deliveryDate'] as Timestamp).toDate() 
              : DateTime.parse(json['deliveryDate']))
          : null,
      paymentMethod: json['paymentMethod'] ?? 'cash',
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'tax': tax,
      'deliveryFee': deliveryFee,
      'total': total,
      'status': status,
      'deliveryAddress': deliveryAddress,
      'contactNumber': contactNumber,
      'orderDate': orderDate,
      'deliveryDate': deliveryDate,
      'paymentMethod': paymentMethod,
      'notes': notes,
    };
  }

  OrderModel copyWith({
    String? id,
    String? userId,
    List<OrderItemModel>? items,
    double? subtotal,
    double? tax,
    double? deliveryFee,
    double? total,
    String? status,
    String? deliveryAddress,
    String? contactNumber,
    DateTime? orderDate,
    DateTime? deliveryDate,
    String? paymentMethod,
    String? notes,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      total: total ?? this.total,
      status: status ?? this.status,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      contactNumber: contactNumber ?? this.contactNumber,
      orderDate: orderDate ?? this.orderDate,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      notes: notes ?? this.notes,
    );
  }
}

class OrderItemModel {
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String? imageUrl;

  OrderItemModel({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    this.imageUrl,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 0,
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
  }

  double get totalPrice => price * quantity;
}