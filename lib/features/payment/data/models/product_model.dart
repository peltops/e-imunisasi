import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final String? id, name, description;
  final double? price;
  final DateTime? createdAt, updatedAt;

  const ProductModel({
    this.id,
    this.name,
    this.description,
    this.price,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        createdAt,
        updatedAt,
      ];

  factory ProductModel.fromDb(Map<String, dynamic> data) {
    return ProductModel(
      id: data['product_id'],
      name: data['name'],
      description: data['description'],
      price: data['price']?.toDouble(),
      createdAt: data['created_at'] != null
          ? DateTime.parse(data['created_at']).toLocal()
          : null,
      updatedAt: data['updated_at'] != null
          ? DateTime.parse(data['updated_at']).toLocal()
          : null,
    );
  }

  factory ProductModel.fromFunctionApi(Map<String, dynamic> data) {
    return ProductModel(
      id: data['id'],
      name: data['name'],
      description: data['description'],
      price: data['price']?.toDouble(),
      createdAt: data['created_at'] != null
          ? DateTime.parse(data['created_at']).toLocal()
          : null,
      updatedAt: data['updated_at'] != null
          ? DateTime.parse(data['updated_at']).toLocal()
          : null,
    );
  }

  Map<String, dynamic> toDb() {
    return {
      if (id != null) "product_id": id,
      if (name != null) "name": name,
      if (description != null) "description": description,
      if (price != null) "price": price,
      if (createdAt != null) "created_at": createdAt?.toIso8601String(),
      if (updatedAt != null) "updated_at": updatedAt?.toIso8601String(),
    };
  }

  Map<String, dynamic> toFunctionApi() {
    return {
      if (id != null) "id": id,
      if (name != null) "name": name,
      if (description != null) "description": description,
      if (price != null) "price": price,
      if (createdAt != null) "created_at": createdAt?.toIso8601String(),
      if (updatedAt != null) "updated_at": updatedAt?.toIso8601String(),
    };
  }
}
