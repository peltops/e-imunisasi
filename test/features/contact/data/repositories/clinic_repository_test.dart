import 'package:flutter_test/flutter_test.dart';
import 'package:eimunisasi/features/contact/data/repositories/clinic_repository.dart';
import 'package:eimunisasi/features/health_worker/data/models/clinic_model.dart';
import 'package:eimunisasi/core/models/pagination_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}
class MockFunctionsClient extends Mock implements FunctionsClient {}

void main() {
    group('ClinicRepository', () {
        final mockFunctionsClient = MockFunctionsClient();
        final mockSupabaseClient = MockSupabaseClient();
        final repository = ClinicRepository(mockSupabaseClient);
        final queryParameters = {
            'page': '1',
            'pageSize': '10',
            'search': 'Clinic',
        };
        final dataJson = {
            'id': '1',
            'name': 'Clinic Name',
            'address': '123 Street',
            'motto': 'Health First',
            'phone_number': '1234567890',
            'photos': ['photo1.jpg', 'photo2.jpg'],
        };
        final responseJsonClinics = {
            'data': [dataJson],
            'metadata': {'total': 1, 'page': 1, 'pageSize': 10},
        };

        setUp(() {
            reset(mockSupabaseClient);
        });

        group('getClinics', () {
            test('returns a list of clinics when successful', () async {
                when(() => mockFunctionsClient.invoke(
                    'get-clinics',
                    queryParameters: queryParameters,
                    method: HttpMethod.get,
                ))
                    .thenAnswer((_) async => FunctionResponse(
                    status: 200,
                    data: responseJsonClinics,
                ));
                when(() => mockSupabaseClient.functions).thenReturn(mockFunctionsClient);

                final result = await repository.getClinics(page: 1, perPage: 10, search: 'Clinic');

                expect(result, isA<BasePagination<ClinicModel>>());
                expect(result.data?.length, 1);
                expect(result.data?.first.id, '1');
            });

            test('returns an empty list of clinics when successful', () async {
                when(() => mockFunctionsClient.invoke(
                    'get-clinics',
                    queryParameters: queryParameters,
                    method: HttpMethod.get,
                ))
                    .thenAnswer((_) async => FunctionResponse(
                    status: 200,
                    data: {'data': [], 'metadata': {'total': 0, 'page': 1, 'pageSize': 10}},
                ));
                when(() => mockSupabaseClient.functions).thenReturn(mockFunctionsClient);

                final result = await repository.getClinics(page: 1, perPage: 10, search: 'Clinic');

                expect(result, isA<BasePagination<ClinicModel>>());
                expect(result.data, List<ClinicModel>.empty());
                expect(result.data?.length, 0);
            });

            test('throws an exception when an error occurs', () async {
                when(() => mockFunctionsClient.invoke(
                    'get-clinics',
                    queryParameters: queryParameters,
                    method: HttpMethod.get,
                ))
                    .thenAnswer((_) async => FunctionResponse(
                    status: 500,
                    data: {'error': 'Internal Server Error'},
                ));
                when(() => mockSupabaseClient.functions).thenReturn(mockFunctionsClient);

                expect(() => repository.getClinics(page: 1, perPage: 10, search: 'Clinic'), throwsException);
            });
        });
    });
}