import 'package:eimunisasi/features/payment/data/models/order_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OrderModel', () {
    test('fromSeribase should correctly parse JSON data', () {
      final DateTime testDate = DateTime(2023);
      final Map<String, dynamic> json = {
        'order_id': '123',
        'status': 'draft',
        'total_amount': 100.0,
        'created_at': '2023-10-01T00:00:00Z',
        'updated_at': '2023-10-01T00:00:00Z',
        'order_items': {
          'order_item_id': '456',
          'product': {
            'product_id': 'product-1',
            'name': 'Product 1',
            'price': 50.0,
            'quantity': 2,
          },
          'price': 50.0,
          'quantity': 2,
          'created_at': '2023-10-01T00:00:00Z',
          'updated_at': '2023-10-01T00:00:00Z',
        },
      };

      final OrderModel order = OrderModel.fromSeribase(json);

      expect(order.id, '123');
      expect(order.status, 'draft');
      expect(order.totalAmount, 100.0);
      expect(order.createdAt?.year, testDate.year);
      expect(order.updatedAt?.year, testDate.year);
      expect(order.orderItem?.id, '456');
    });

    test('toSeribase should return correct map', () {
      final DateTime testDate = DateTime(2023);
      final OrderModel order = OrderModel(
        id: '123',
        status: 'pending',
        totalAmount: 100.0,
        createdAt: testDate,
        updatedAt: testDate,
        orderItem: OrderItemModel(
          id: '456',
          price: 50.0,
          quantity: 2,
        ),
      );

      final Map<String, dynamic> json = order.toSeribase();

      expect(json['order_id'], '123');
      expect(json['status'], 'pending');
      expect(json['total_amount'], 100.0);
      expect(json['created_at'], testDate.toIso8601String());
      expect(json['updated_at'], testDate.toIso8601String());
    });
  });

  group('OrderItemModel', () {
    test('fromSeribase should correctly parse JSON data', () {
      final DateTime testDate = DateTime(2023);
      final Map<String, dynamic> json = {
        'order_item_id': '456',
        'product': {'id': '789', 'name': 'Test Product'},
        'price': 50.0,
        'quantity': 2,
        'created_at': testDate.toIso8601String(),
        'updated_at': testDate.toIso8601String(),
      };

      final OrderItemModel orderItem = OrderItemModel.fromSeribase(json);

      expect(orderItem.id, '456');
      expect(orderItem.price, 50.0);
      expect(orderItem.quantity, 2);
      expect(orderItem.createdAt?.year, testDate.year);
      expect(orderItem.updatedAt?.year, testDate.year);
    });

    test('toSeribase should return correct map', () {
      final DateTime testDate = DateTime(2023);
      final OrderItemModel orderItem = OrderItemModel(
        id: '456',
        price: 50.0,
        quantity: 2,
        createdAt: testDate,
        updatedAt: testDate,
      );

      final Map<String, dynamic> json = orderItem.toSeribase();

      expect(json['order_item_id'], '456');
      expect(json['price'], 50.0);
      expect(json['quantity'], 2);
      expect(json['created_at'], testDate.toIso8601String());
      expect(json['updated_at'], testDate.toIso8601String());
    });
  });
}
