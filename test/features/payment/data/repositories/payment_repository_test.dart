import 'package:eimunisasi/core/models/base_response_model.dart';
import 'package:eimunisasi/features/payment/data/models/payment_initiate_request_model.dart';
import 'package:eimunisasi/features/payment/data/models/payment_initiate_response_model.dart';
import 'package:eimunisasi/features/payment/data/models/order_model.dart';
import 'package:eimunisasi/features/payment/data/repositories/payment_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockFunctionsClient extends Mock implements FunctionsClient {}

class MockGotrueClient extends Mock implements GoTrueClient {}

class MockSession extends Mock implements Session {}

void main() {
  late PaymentRepository repository;
  late MockSupabaseClient mockSupabaseClient;
  late MockFunctionsClient mockFunctionsClient;
  late MockGotrueClient mockGotrueClient;
  late MockSession mockSession;
  setUpAll(() async {
    // Set up SharedPreferences for testing
    SharedPreferences.setMockInitialValues({});
    // Load environment variables from .env file
    dotenv.testLoad(fileInput: '''
      PAYMENT_GATEWAY=midtrans
    ''');
    await Supabase.initialize(
      url: 'https://test.com',
      anonKey: 'test',
    );
  });

  setUp(() {
    mockSupabaseClient = MockSupabaseClient();
    mockFunctionsClient = MockFunctionsClient();
    mockSession = MockSession();
    mockGotrueClient = MockGotrueClient();
    repository = PaymentRepository(supabaseClient: mockSupabaseClient);

    when(() => mockSupabaseClient.functions).thenReturn(mockFunctionsClient);
    when(() => mockSupabaseClient.auth).thenReturn(mockGotrueClient);
  });

  group('initiate payment', () {
    final request = PaymentInitiateRequestModel(
      gateway: 'gateway',
      currency: 'USD',
      items: [
        ItemModel(
          id: 'item-1',
          quantity: 1,
        )
      ],
    );

    test('should return payment initiate response when successful', () async {
      // Arrange
      when(() => mockSession.accessToken).thenReturn('access-token');
      when(() => mockGotrueClient.currentSession).thenReturn(mockSession);
      when(() => mockSupabaseClient.auth).thenReturn(mockGotrueClient);

      when(() => mockFunctionsClient.invoke(
            any(),
            method: HttpMethod.post,
            body: any(named: 'body'),
            headers: any(named: 'headers'),
          )).thenAnswer(
        (_) async => FunctionResponse(
          data: {
            "is_successful": true,
            "message": "Payment initiated successfully",
            "data": {
              "order_id": "dcf0fada-f9c3-4998-b607-ddae38e88cca",
              "gateway": "midtrans",
              "redirect_url":
                  "https://app.sandbox.midtrans.com/snap/v4/redirection/b3d75df0-3676-4e3d-a094-3f5c7df73d4e",
              "token": "b3d75df0-3676-4e3d-a094-3f5c7df73d4e"
            }
          },
          status: 200,
        ),
      );

      // Act
      final result = await repository.initiate(request);

      // Assert
      expect(result, isA<BaseResponse<PaymentInitiateResponseModel>>());
      verify(() => mockFunctionsClient.invoke(
            'payments/initiate',
            method: HttpMethod.post,
            body: any(named: 'body'),
            headers: any(named: 'headers'),
          )).called(1);
    });

    test('should throw exception when api call fails', () async {
      // Arrange
      when(() => mockSession.accessToken).thenReturn('access-token');
      when(() => mockGotrueClient.currentSession).thenReturn(mockSession);
      when(() => mockSupabaseClient.auth).thenReturn(mockGotrueClient);
      when(() => mockFunctionsClient.invoke(
            any(),
            method: HttpMethod.post,
            body: any(named: 'body'),
            headers: any(named: 'headers'),
          )).thenAnswer(
        (_) async => FunctionResponse(
          data: {'error': 'Failed'},
          status: 400,
        ),
      );

      // Act & Assert
      expect(() => repository.initiate(request), throwsException);
    });
  });

  group('get order detail', () {
    final orderId = 'order-123';

    test(
      'should return order detail when successful',
      () async {
        // Arrange
        when(() => mockSession.accessToken).thenReturn('access-token');
        when(() => mockGotrueClient.currentSession).thenReturn(mockSession);
        when(() => mockSupabaseClient.auth).thenReturn(mockGotrueClient);
        when(() => mockFunctionsClient.invoke(
              any(),
              method: HttpMethod.get,
              headers: any(named: 'headers'),
            )).thenAnswer(
          (_) async => FunctionResponse(
            data: {
              'is_successful': true,
              'message': 'Order detail fetched successfully',
              'data': {
                'order_id': orderId,
                'status': 'draft',
                'total_amount': 100.0,
                'created_at': '2023-10-01T00:00:00Z',
                'updated_at': '2023-10-01T00:00:00Z',
                'order_items': {
                  'order_item_id': 'item-1',
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
              },
            },
            status: 200,
          ),
        );

        // Act
        final result = await repository.getOrderDetail(orderId);

        // Assert
        expect(result, isA<BaseResponse<OrderModel>?>());
        verify(() => mockFunctionsClient.invoke(
              'payments/order/$orderId',
              method: HttpMethod.get,
              headers: any(named: 'headers'),
            )).called(1);
      },
    );

    test('should throw exception when api call fails', () async {
      // Arrange
      when(() => mockSession.accessToken).thenReturn('access-token');
      when(() => mockGotrueClient.currentSession).thenReturn(mockSession);
      when(() => mockSupabaseClient.auth).thenReturn(mockGotrueClient);
      when(() => mockFunctionsClient.invoke(
            any(),
            method: HttpMethod.get,
            headers: any(named: 'headers'),
          )).thenAnswer((_) async => FunctionResponse(
            data: {'error': 'Failed'},
            status: 400,
          ));

      // Act & Assert
      expect(() => repository.getOrderDetail(orderId), throwsException);
    });
  });
}
