import 'package:eimunisasi/features/authentication/data/models/user_profile.dart';
import 'package:eimunisasi/features/health_worker/data/models/health_worker_model.dart';
import 'package:eimunisasi/features/health_worker/data/repositories/health_worker_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eimunisasi/features/vaccination/data/repositories/appointment_repository.dart';
import 'package:eimunisasi/features/vaccination/data/models/appointment_model.dart';
import 'package:mock_supabase_http_client/mock_supabase_http_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockHealthWorkerRepository extends Mock
    implements HealthWorkerRepository {}

void main() {
  group('AppointmentRepository', () {
    late SupabaseClient supabaseClient;
    late AppointmentRepository repository;
    late HealthWorkerRepository healthWorkerRepository;
    late var mockHttpClient;
    final data1 = AppointmentModel(
      id: 'd8bfed26-f491-4478-b182-fdc2e8074212c',
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
      healthWorkerRepository = MockHealthWorkerRepository();
      repository = AppointmentRepository(
        healthWorkerRepository,
        supabaseClient,
      );
    });

    tearDown(() async {
      mockHttpClient.reset();
    });

    tearDownAll(() {
      mockHttpClient.close();
    });

    group('getAppointments', () {
      test('returns a list of appointments when successful', () async {
        await repository.setAppointment(data1);
        final result = await repository.getAppointments(
          userId: '1',
        );

        expect(result, isA<List<AppointmentModel>>());
        expect(result.length, 1);
      });
    });

    group('getAppointment', () {
      test('returns an appointment when successful', () async {
        when(() => healthWorkerRepository.getHealthWorkerById(any()))
            .thenAnswer(
          (_) async => HealthWorkerModel(
            id: '1',
            fullName: 'John Doe',
          ),
        );
        await repository.setAppointment(data1);
        final result = await repository.getAppointment(
          id: 'd8bfed26-f491-4478-b182-fdc2e8074212c',
        );

        expect(result, isA<AppointmentModel>());
        expect(result.id, data1.id);
      });
    });

    group('setAppointment', () {
      test('inserts and returns an appointment when successful', () async {
        final result = await repository.setAppointment(data1.copyWith(
          note: 'Note Set',
          purpose: 'Purpose Set',
        ));

        expect(result, isA<AppointmentModel>());
        expect(result.note, 'Note Set');
        expect(result.purpose, 'Purpose Set');
      });
    });

    group('updateAppointment', () {
      test('updates and returns the appointment when successful', () async {
        await repository.setAppointment(data1);
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
