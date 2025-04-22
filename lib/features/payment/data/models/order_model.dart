import 'package:equatable/equatable.dart';

import 'product_model.dart';

class OrderModel extends Equatable {
  final String? id, status;
  final double? totalAmount;
  final OrderItemModel? orderItem;
  final DateTime? createdAt, updatedAt;

  const OrderModel({
    this.id,
    this.status,
    this.orderItem,
    this.totalAmount,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        status,
        totalAmount,
        createdAt,
        updatedAt,
      ];

  factory OrderModel.fromSeribase(Map<String, dynamic> data) {
    return OrderModel(
      id: data['order_id'],
      status: data['status'],
      totalAmount: data['total_amount']?.toDouble(),
      createdAt: data['created_at'] != null
          ? DateTime.parse(data['created_at']).toLocal()
          : null,
      updatedAt: data['updated_at'] != null
          ? DateTime.parse(data['updated_at']).toLocal()
          : null,
      orderItem: OrderItemModel.fromSeribase(data['order_items']),
    );
  }

  Map<String, dynamic> toSeribase() {
    return {
      if (id != null) "order_id": id,
      if (status != null) "status": status,
      if (totalAmount != null) "total_amount": totalAmount,
      if (createdAt != null) "created_at": createdAt?.toIso8601String(),
      if (updatedAt != null) "updated_at": updatedAt?.toIso8601String(),
      if (orderItem != null) "order_item": orderItem?.toSeribase(),
    };
  }
}

class OrderItemModel extends Equatable {
  final String? id;
  final ProductModel? product;
  final double? price;
  final int? quantity;
  final DateTime? createdAt, updatedAt;

  const OrderItemModel({
    this.id,
    this.product,
    this.price,
    this.quantity,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        product,
        price,
        quantity,
        createdAt,
        updatedAt,
      ];

  factory OrderItemModel.fromSeribase(Map<String, dynamic> data) {
    return OrderItemModel(
      id: data['order_item_id'],
      product: ProductModel.fromDb(data['product']),
      price: data['price']?.toDouble(),
      quantity: data['quantity']?.toInt(),
      createdAt: data['created_at'] != null
          ? DateTime.parse(data['created_at']).toLocal()
          : null,
      updatedAt: data['updated_at'] != null
          ? DateTime.parse(data['updated_at']).toLocal()
          : null,
    );
  }

  Map<String, dynamic> toSeribase() {
    return {
      if (id != null) "order_item_id": id,
      if (product != null) "product": product?.toDb(),
      if (price != null) "price": price,
      if (quantity != null) "quantity": quantity,
      if (createdAt != null) "created_at": createdAt?.toIso8601String(),
      if (updatedAt != null) "updated_at": updatedAt?.toIso8601String(),
    };
  }
}
