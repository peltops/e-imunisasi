import 'package:eimunisasi/features/payment/data/models/payment_initiate_request_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PaymentInitiateRequestModel', () {
    final tPaymentModel = PaymentInitiateRequestModel(
      gateway: 'test_gateway',
      currency: 'IDR',
      items: [
        ItemModel(
          id: 'test_product',
          quantity: 1,
        )
      ],
    );

    final tMap = {
      'gateway': 'test_gateway',
      'currency': 'IDR',
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
  });
}