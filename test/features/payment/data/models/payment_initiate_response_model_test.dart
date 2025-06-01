import 'package:eimunisasi/features/payment/data/models/payment_initiate_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PaymentInitiateResponseModel', () {
    final tPaymentInitiateResponse = PaymentInitiateResponseModel(
      orderId: 'order123',
      gateway: 'midtrans',
      redirectUrl: 'https://example.com',
      token: 'token123',
    );

    final tPaymentInitiateMap = {
      'order_id': 'order123',
      'gateway': 'midtrans',
      'redirect_url': 'https://example.com',
      'token': 'token123'
    };

    test('should create PaymentInitiateResponseModel from map', () {
      // act
      final result =
          PaymentInitiateResponseModel.fromSeribase(tPaymentInitiateMap);

      // assert
      expect(result, equals(tPaymentInitiateResponse));
    });

    test('should create map from PaymentInitiateResponseModel', () {
      // act
      final result = tPaymentInitiateResponse.toSeribase();

      // assert
      expect(result, equals(tPaymentInitiateMap));
    });

    test('should return true when comparing two identical models', () {
      // arrange
      final model1 = PaymentInitiateResponseModel(
          orderId: 'order123',
          gateway: 'midtrans',
          redirectUrl: 'https://example.com',
          token: 'token123');

      // act & assert
      expect(model1, equals(tPaymentInitiateResponse));
    });

    test('should handle null values correctly', () {
      // arrange
      final nullModel = PaymentInitiateResponseModel();
      final nullMap = {};

      // act
      final result = nullModel.toSeribase();

      // assert
      expect(result, equals(nullMap));
    });
  });
}
