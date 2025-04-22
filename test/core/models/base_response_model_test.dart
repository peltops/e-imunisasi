import 'package:eimunisasi/core/models/base_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BaseResponse', () {
    test('should create BaseResponse instance with default values', () {
      final response = BaseResponse();
      
      expect(response.isSuccessful, false);
      expect(response.message, null);
      expect(response.error, null);
      expect(response.data, null);
    });

    test('should create BaseResponse instance with provided values', () {
      final response = BaseResponse(
        isSuccessful: true,
        message: 'Success',
        error: 'Error',
        data: 'Data',
      );

      expect(response.isSuccessful, true);
      expect(response.message, 'Success');
      expect(response.error, 'Error');
      expect(response.data, 'Data');
    });

    test('copyWith should return new instance with updated values', () {
      final response = BaseResponse(
        isSuccessful: false,
        message: 'Initial',
        error: 'InitialError',
        data: 'InitialData',
      );

      final updatedResponse = response.copyWith(
        isSuccessful: true,
        message: 'Updated',
        error: 'UpdatedError',
        data: 'UpdatedData',
      );

      expect(updatedResponse.isSuccessful, true);
      expect(updatedResponse.message, 'Updated');
      expect(updatedResponse.error, 'UpdatedError');
      expect(updatedResponse.data, 'UpdatedData');
    });

    test('fromJson should correctly parse JSON data', () {
      final json = {
        'isSuccessful': true,
        'message': 'Success message',
        'error': {'value': 'Error data'},
        'data': {'value': 'Test data'},
      };

      final response = BaseResponse<Map<String, String>>.fromJson(
        json,
        (json) => Map<String, String>.from(json),
      );

      expect(response.isSuccessful, true);
      expect(response.message, 'Success message');
      expect(response.error, {'value': 'Error data'});
      expect(response.data, {'value': 'Test data'});
    });
  });
}