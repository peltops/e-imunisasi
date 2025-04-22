import 'package:eimunisasi/features/payment/data/models/product_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final testProductModel = ProductModel(
    id: '1',
    name: 'Test Product',
    description: 'Test Description',
    price: 100.0,
    createdAt: DateTime(2023),
    updatedAt: DateTime(2023),
  );

  group('ProductModel', () {
    test('should create ProductModel instance with all properties', () {
      expect(testProductModel.id, '1');
      expect(testProductModel.name, 'Test Product');
      expect(testProductModel.description, 'Test Description');
      expect(testProductModel.price, 100.0);
      expect(testProductModel.createdAt, DateTime(2023));
      expect(testProductModel.updatedAt, DateTime(2023));
    });

    test('fromDb should return valid ProductModel', () {
      final Map<String, dynamic> dbData = {
        'product_id': '1',
        'name': 'Test Product',
        'description': 'Test Description',
        'price': 100.0,
        'created_at': '2023-01-01T00:00:00.000Z',
        'updated_at': '2023-01-01T00:00:00.000Z',
      };

      final result = ProductModel.fromDb(dbData);
      expect(result, isA<ProductModel>());
      expect(result.id, '1');
    });

    test('fromFunctionApi should return valid ProductModel', () {
      final Map<String, dynamic> apiData = {
        'id': '1',
        'name': 'Test Product',
        'description': 'Test Description',
        'price': 100.0,
        'created_at': '2023-01-01T00:00:00.000Z',
        'updated_at': '2023-01-01T00:00:00.000Z',
      };

      final result = ProductModel.fromFunctionApi(apiData);
      expect(result, isA<ProductModel>());
      expect(result.id, '1');
    });

    test('toDb should return valid map', () {
      final result = testProductModel.toDb();
      expect(result, isA<Map<String, dynamic>>());
      expect(result['product_id'], '1');
      expect(result['name'], 'Test Product');
    });

    test('toFunctionApi should return valid map', () {
      final result = testProductModel.toFunctionApi();
      expect(result, isA<Map<String, dynamic>>());
      expect(result['id'], '1');
      expect(result['name'], 'Test Product');
    });

    test('props should contain all properties', () {
      expect(testProductModel.props, [
        testProductModel.id,
        testProductModel.name,
        testProductModel.description,
        testProductModel.price,
        testProductModel.createdAt,
        testProductModel.updatedAt,
      ]);
    });
  });
}
