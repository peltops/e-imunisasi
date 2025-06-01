import 'package:eimunisasi/features/authentication/data/models/user_profile.dart';
import 'package:eimunisasi/features/health_worker/data/models/health_worker_model.dart';
import 'package:eimunisasi/features/health_worker/data/repositories/health_worker_repository.dart';
import 'package:eimunisasi/features/payment/data/models/payment_initiate_request_model.dart';
import 'package:eimunisasi/features/payment/data/repositories/payment_repository.dart';
import 'package:eimunisasi/features/vaccination/data/models/appointment_payment_entity.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eimunisasi/features/vaccination/data/repositories/appointment_repository.dart';
import 'package:eimunisasi/features/vaccination/data/models/appointment_model.dart';
import 'package:mock_supabase_http_client/mock_supabase_http_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockHealthWorkerRepository extends Mock
    implements HealthWorkerRepository {}

class MockPaymentRepository extends Mock implements PaymentRepository {}

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockFunctionsClient extends Mock implements FunctionsClient {}

void main() {
  group('AppointmentRepository', () {
    late SupabaseClient supabaseClient;
    late AppointmentRepository repository;
    late MockSupabaseHttpClient mockHttpClient;
    final data1 = AppointmentModel(
      id: 'd8bfed26-f491-4478-b182-fdc2e8074212c',
      orderId: 'd8bfed26-f491-4478-b182-fdc2e8074212c',
      parent: UserProfile(
        uid: '1',
      ),
      healthWorker: HealthWorkerModel(
        id: '1',
        fullName: 'John Doe',
      ),
      date: DateTime.now(),
      note: 'Note',
      purpose: 'Purpose',
    );

    setUp(() {
      mockHttpClient = MockSupabaseHttpClient();
      supabaseClient = SupabaseClient(
        'https://test.com',
        'test',
        httpClient: mockHttpClient,
      );
      repository = AppointmentRepository(
        supabaseClient,
      );
    });

    tearDown(() async {
      mockHttpClient.reset();
    });

    tearDownAll(() {
      mockHttpClient.close();
    });

    setUpAll(() {
      registerFallbackValue(
        PaymentInitiateRequestModel(),
      );
    });

    group('getAppointments', () {
      test('returns a list of appointments when successful', () async {
        await supabaseClient
            .from(AppointmentModel.tableName)
            .insert(data1.toSeribase());
        final result = await repository.getAppointments(
          userId: '1',
        );

        expect(result, isA<List<AppointmentModel>>());
        expect(result.length, 1);
      });
    });

    group('getAppointment', () {
      late MockSupabaseClient supabaseClient;
      late MockFunctionsClient functionsClient;
      late AppointmentRepository repository;
      late MockHealthWorkerRepository healthWorkerRepository;
      late GoTrueClient authClient;

      setUp(() {
        supabaseClient = MockSupabaseClient();
        functionsClient = MockFunctionsClient();
        authClient = GoTrueClient(url: 'fake-url', headers: {});
        healthWorkerRepository = MockHealthWorkerRepository();
        when(() => supabaseClient.auth).thenReturn(authClient);
        when(() => supabaseClient.functions).thenReturn(functionsClient);

        repository = AppointmentRepository(
          supabaseClient,
        );
      });

      tearDown(() {
        reset(supabaseClient);
        reset(functionsClient);
        reset(healthWorkerRepository);
      });

      test('should throw exception when status is not 200 or 201', () async {
        when(() => functionsClient.invoke(
              any(),
              method: HttpMethod.get,
              headers: any(named: 'headers'),
            )).thenAnswer((_) async => FunctionResponse(
              status: 400,
              data: null,
            ));

        expect(
          () => repository.getAppointment(id: 'test-id'),
          throwsA(isA<Exception>()),
        );
      });

      test('should return null order when order data is null', () async {
        when(() => functionsClient.invoke(
              any(),
              method: HttpMethod.get,
              headers: any(named: 'headers'),
            )).thenAnswer((_) async => FunctionResponse(
              status: 200,
              data: {
                "data": {
                  "id": "test-id",
                  "health_worker": {
                    "id": "health-worker-id",
                    "full_name": "Test Worker",
                  },
                  "order": null,
                },
              },
            ));

        final result = await repository.getAppointment(id: 'test-id');

        expect(result.order, isNull);
        expect(result.appointment, isNotNull);
        expect(result.appointment?.healthWorker?.id, 'health-worker-id');
      });

      test('should return AppointmentOrderEntity when data is valid', () async {
        when(() => functionsClient.invoke(
              any(),
              method: HttpMethod.get,
              headers: any(named: 'headers'),
            )).thenAnswer((_) async => FunctionResponse(
              status: 200,
              data: {
                "data": {
                  "id": "test-id",
                  "inspector_id": "health-worker-id",
                  "order": {
                    "order_id": "order-id",
                  },
                },
              },
            ));

        when(() => healthWorkerRepository.getHealthWorkerById(any()))
            .thenAnswer((_) async => HealthWorkerModel(
                  id: 'health-worker-id',
                  fullName: 'Test Worker',
                ));

        final result = await repository.getAppointment(id: 'test-id');

        expect(result, isA<AppointmentOrderEntity>());
        expect(result.appointment?.id, 'test-id');
        expect(result.order?.id, 'order-id');
      });
      test('throws an exception when the appointment is not found', () async {
        when(() => functionsClient.invoke(
              any(),
              method: HttpMethod.get,
              headers: any(named: 'headers'),
            )).thenAnswer((_) async => FunctionResponse(
              status: 404,
              data: null,
            ));

        expect(
          () => repository.getAppointment(id: 'test-id'),
          throwsA(isA<Exception>()),
        );
      });

      test('throws an exception when the appointment is not found', () async {
        when(() => functionsClient.invoke(
              any(),
              method: HttpMethod.get,
              headers: any(named: 'headers'),
            )).thenAnswer((_) async => FunctionResponse(
              status: 200,
              data: {
                "data": null,
              },
            ));

        expect(
          () => repository.getAppointment(id: 'test-id'),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('setAppointment', () {
      late MockSupabaseClient supabaseClient;
      late MockFunctionsClient functionsClient;
      late AppointmentRepository repository;
      late MockHealthWorkerRepository healthWorkerRepository;
      late GoTrueClient authClient;

      setUp(() {
        // Load environment variables from .env file
        dotenv.testLoad(fileInput: '''
            PAYMENT_GATEWAY=midtrans
          ''');
        supabaseClient = MockSupabaseClient();
        functionsClient = MockFunctionsClient();
        authClient = GoTrueClient(url: 'fake-url', headers: {});
        healthWorkerRepository = MockHealthWorkerRepository();
        when(() => supabaseClient.auth).thenReturn(authClient);
        when(() => supabaseClient.functions).thenReturn(functionsClient);

        repository = AppointmentRepository(
          supabaseClient,
        );
      });

      tearDown(() {
        reset(supabaseClient);
        reset(functionsClient);
        reset(healthWorkerRepository);
      });
      test('inserts and returns an appointment when successful', () async {
        when(() => functionsClient.invoke(
              any(),
              method: HttpMethod.post,
              body: any(named: 'body'),
              headers: any(named: 'headers'),
            )).thenAnswer((_) async => FunctionResponse(
              status: 200,
              data: {
                "data": {
                  "id": "test-id",
                  "inspector_id": "health-worker-id",
                  "note": "Note Set",
                  "purpose": "Purpose Set",
                  "order": {
                    "order_id": "order-id",
                  },
                },
              },
            ));

        final result = await repository.setAppointment(data1.copyWith(
          note: 'Note Set',
          purpose: 'Purpose Set',
        ));

        expect(result, isA<AppointmentOrderEntity>());
        expect(result.appointment?.note, 'Note Set');
        expect(result.appointment?.purpose, 'Purpose Set');
      });
    });

    group('updateAppointment', () {
      test('updates and returns the appointment when successful', () async {
        await supabaseClient
            .from(AppointmentModel.tableName)
            .insert(data1.toSeribase());

        final result = await repository.updateAppointment(
          data1.copyWith(
            date: DateTime.now(),
            note: 'Note Updated',
            purpose: 'Purpose Updated',
          ),
        );

        expect(result, isA<AppointmentModel>());
        expect(result.id, data1.id);
        expect(result.note, 'Note Updated');
        expect(result.purpose, 'Purpose Updated');
      });
    });

    group('deleteAppointment', () {
      test('deletes the appointment when successful', () async {
        expect(() => repository.deleteAppointment('1'), returnsNormally);
      });
    });
  });
}
