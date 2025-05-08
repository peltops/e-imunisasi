import 'package:eimunisasi/features/payment/data/models/payment_initiate_request_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PaymentInitiateRequestModel', () {
    final tPaymentModel = PaymentInitiateRequestModel(
      gateway: 'test_gateway',
      currency: 'idr',
      items: [
        ItemModel(
          id: 'test_product',
          quantity: 1,
        )
      ],
    );

    final tMap = {
      'gateway': 'test_gateway',
      'currency': 'idr',
      'items': [
        {
          'name': 'test_product',
          'quantity': 1,
        }
      ]
    };

    test('should create PaymentInitiateRequestModel from map', () {
      // act
      final result = PaymentInitiateRequestModel.fromSeribase(tMap);

      // assert
      expect(result, isA<PaymentInitiateRequestModel>());
      expect(result.gateway, tMap['gateway']);
      expect(result.currency, tMap['currency']);
      expect(result.items?.length, 1);
    });

    test('should return map from PaymentInitiateRequestModel', () {
      // act
      final result = tPaymentModel.toSeribase();

      // assert
      expect(result, isA<Map<String, dynamic>>());
      expect(result['gateway'], tPaymentModel.gateway);
      expect(result['currency'], tPaymentModel.currency);
      expect(result['items'], isA<List>());
    });

    test('should return null items when items data is null', () {
      // arrange
      final map = {'gateway': 'test_gateway', 'currency': 'IDR'};

      // act
      final result = PaymentInitiateRequestModel.fromSeribase(map);

      // assert
      expect(result.items, isNull);
    });

    test('should implement Equatable', () {
      // arrange
      final model1 = PaymentInitiateRequestModel(
        gateway: 'test',
        currency: 'IDR',
        items: [],
      );
      final model2 = PaymentInitiateRequestModel(
        gateway: 'test',
        currency: 'IDR',
        items: [],
      );

      // assert
      expect(model1, model2);
    });

    test('copyWith should return a new instance with updated values', () {
      // arrange
      final model = PaymentInitiateRequestModel(
        gateway: 'test',
        currency: 'IDR',
        items: [],
      );

      // act
      final result = model.copyWith(
        gateway: 'new_gateway',
        currency: 'USD',
      );

      // assert
      expect(result.gateway, 'new_gateway');
      expect(result.currency, 'USD');
      expect(result.items, []);
    });
  });

  group('ItemModel', () {
    final tItemModel = ItemModel(
      id: 'test_id',
      quantity: 1,
    );

    final tMap = {
      'id': 'test_id',
      'quantity': 1,
    };

    test('should create ItemModel from map', () {
      // act
      final result = ItemModel.fromSeribase(tMap);

      // assert
      expect(result, isA<ItemModel>());
      expect(result.id, tMap['id']);
      expect(result.quantity, tMap['quantity']);
    });

    test('should return map from ItemModel', () {
      // act
      final result = tItemModel.toSeribase();

      // assert
      expect(result, isA<Map<String, dynamic>>());
      expect(result['id'], tItemModel.id);
      expect(result['quantity'], tItemModel.quantity);
    });

    test('should implement Equatable', () {
      // arrange
      final model1 = ItemModel(
        id: 'test',
        quantity: 1,
      );
      final model2 = ItemModel(
        id: 'test',
        quantity: 1,
      );

      // assert
      expect(model1, model2);
    });
  });
}
