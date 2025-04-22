import 'package:equatable/equatable.dart';

class PaymentInitiateRequestModel extends Equatable {
  final String? gateway, currency;
  final List<ItemModel>? items;

  const PaymentInitiateRequestModel({
    this.gateway,
    this.currency,
    this.items,
  });

  PaymentInitiateRequestModel copyWith({
    String? gateway,
    String? currency,
    List<ItemModel>? items,
  }) {
    return PaymentInitiateRequestModel(
      gateway: gateway ?? this.gateway,
      currency: currency ?? this.currency,
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [
        gateway,
        currency,
        items,
      ];

  factory PaymentInitiateRequestModel.fromSeribase(Map<String, dynamic> data) {
    return PaymentInitiateRequestModel(
      gateway: data['gateway'],
      currency: data['currency'],
      items: () {
        if (data['items'] == null) {
          return null;
        }
        try {
          return List<ItemModel>.from(
              data['items'].map((x) => ItemModel.fromSeribase(x)));
        } catch (e) {
          return null;
        }
      }(),
    );
  }

  Map<String, dynamic> toSeribase() {
    return {
      if (gateway != null) "gateway": gateway,
      if (currency != null) "currency": currency,
      if (items != null)
        "items": List<dynamic>.from(items!.map((x) => x.toSeribase())),
    };
  }
}

class ItemModel extends Equatable {
  final String? id;
  final int? quantity;

  const ItemModel({
    this.id,
    this.quantity,
  });

  @override
  List<Object?> get props => [
        id,
        quantity,
      ];

  factory ItemModel.fromSeribase(Map<String, dynamic> data) {
    return ItemModel(
      id: data['id'],
      quantity: data['quantity'],
    );
  }

  Map<String, dynamic> toSeribase() {
    return {
      if (id != null) "id": id,
      if (quantity != null) "quantity": quantity,
    };
  }
}
