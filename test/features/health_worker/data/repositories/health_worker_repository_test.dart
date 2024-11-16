import 'package:flutter_test/flutter_test.dart';
import 'package:eimunisasi/features/health_worker/data/repositories/health_worker_repository.dart';
import 'package:eimunisasi/features/health_worker/data/models/health_worker_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockFunctionsClient extends Mock implements FunctionsClient {}

void main() {
  group('HealthWorkerRepository', () {
    final mockFunctionsClient = MockFunctionsClient();
    final mockSupabaseClient = MockSupabaseClient();
    final repository = HealthWorkerRepository(mockSupabaseClient);
    final queryParameters = {
      'page': '1',
      'pageSize': '10',
      'search': 'John',
    };
    final dataJson = {
      'id': '1',
      'clinic': {
        'id': '1',
        'name': 'Clinic Name',
        'address': '123 Street',
        'motto': 'Health First',
        'phone_number': '1234567890',
        'photos': ['photo1.jpg', 'photo2.jpg'],
      },
      'email': 'test@example.com',
      'schedule': [
        {
          'day': 'Monday',
          'start_time': '2023-10-10T08:00:00.000Z',
          'end_time': '2023-10-10T12:00:00.000Z'
        }
      ],
      'practice_schedules': [
        {
          'day': 'Tuesday',
          'start_time': '2023-10-11T08:00:00.000Z',
          'end_time': '2023-10-11T12:00:00.000Z'
        }
      ],
      'no_kartu_keluarga': '1234567890',
      'full_name': 'John Doe',
      'no_induk_kependudukan': '9876543210',
      'phone_number': '0987654321',
      'avatar_url': 'http://example.com/photo.jpg',
      'profession': 'Doctor',
      'date_of_birth': '1980-01-01T00:00:00.000Z',
      'place_of_birth': 'City',
    };
    final responseJsonHealthWorkers = {
      'data': [dataJson],
      'isSuccessful': true,
    };

    setUp(() {
      reset(mockSupabaseClient);
    });

    group('getHealthWorkers', () {
      test('returns a list of health workers when successful', () async {
        when(() => mockFunctionsClient.invoke(
              'get-health-workers',
              queryParameters: queryParameters,
              method: HttpMethod.get,
            )).thenAnswer((_) async => FunctionResponse(
              status: 200,
              data: responseJsonHealthWorkers,
            ));
        when(() => mockSupabaseClient.functions)
            .thenReturn(mockFunctionsClient);

        final result = await repository.getHealthWorkers(
            page: 1, perPage: 10, search: 'John');

        expect(result, isA<List<HealthWorkerModel>>());
        expect(result.length, 1);
        expect(result.first.id, '1');
      });

      test('returns an empty list of health workers when successful', () async {
        when(
          () => mockFunctionsClient.invoke(
            'get-health-workers',
            queryParameters: queryParameters,
            method: HttpMethod.get,
          ),
        ).thenAnswer(
          (_) async => FunctionResponse(
            status: 200,
            data: {'data': []},
          ),
        );
        when(() => mockSupabaseClient.functions).thenReturn(
          mockFunctionsClient,
        );

        final result = await repository.getHealthWorkers(
            page: 1, perPage: 10, search: 'John');

        expect(result, isA<List<HealthWorkerModel>>());
        expect(result, List<HealthWorkerModel>.empty());
        expect(result.length, 0);
      });

      test('throws an exception when an error occurs', () async {
        when(
          () => mockFunctionsClient.invoke(
            'get-health-workers',
            queryParameters: queryParameters,
            method: HttpMethod.get,
          ),
        ).thenAnswer(
          (_) async => FunctionResponse(
            status: 500,
            data: {'error': 'Internal Server Error'},
          ),
        );
        when(() => mockSupabaseClient.functions).thenReturn(
          mockFunctionsClient,
        );

        expect(
          () => repository.getHealthWorkers(
            page: 1,
            perPage: 10,
            search: 'John',
          ),
          throwsException,
        );
      });
    });

    group('getHealthWorkerById', () {
      test('returns a health worker when successful', () async {
        when(() => mockFunctionsClient.invoke(
              'get-health-worker/1',
              method: HttpMethod.get,
            )).thenAnswer((_) async => FunctionResponse(
              status: 200,
              data: {'data': dataJson},
            ));
        when(() => mockSupabaseClient.functions)
            .thenReturn(mockFunctionsClient);

        final result = await repository.getHealthWorkerById('1');

        expect(result, isA<HealthWorkerModel>());
        expect(result?.id, '1');
      });

      test('returns null when successful', () async {
        when(
          () => mockFunctionsClient.invoke(
            'get-health-worker/1',
            method: HttpMethod.get,
          ),
        ).thenAnswer(
          (_) async => FunctionResponse(
            status: 404,
            data: {'data': null},
          ),
        );
        when(() => mockSupabaseClient.functions).thenReturn(
          mockFunctionsClient,
        );

        final result = await repository.getHealthWorkerById('1');

        expect(result, isNull);
      });

      test('throws an exception when an error occurs', () async {
        when(
          () => mockFunctionsClient.invoke(
            'get-health-worker/1',
            method: HttpMethod.get,
          ),
        ).thenAnswer(
          (_) async => FunctionResponse(
            status: 500,
            data: {'error': 'Internal Server Error'},
          ),
        );
        when(() => mockSupabaseClient.functions).thenReturn(
          mockFunctionsClient,
        );

        expect(
          () => repository.getHealthWorkerById('1'),
          throwsException,
        );
      });
    });
  });
}
