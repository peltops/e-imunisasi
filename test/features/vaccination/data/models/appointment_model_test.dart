import 'package:eimunisasi/features/authentication/data/models/user.dart';
import 'package:eimunisasi/features/health_worker/data/models/health_worker_model.dart';
import 'package:eimunisasi/features/profile/data/models/anak.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eimunisasi/features/vaccination/data/models/appointment_model.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([
  MockSpec<Anak>(),
  MockSpec<Users>(),
  MockSpec<HealthWorkerModel>(),
])
import 'appointment_model_test.mocks.dart';

void main() {
  group('AppointmentModel', () {
    test('fromSeribase creates an instance from a valid map', () {
      final map = {
        'id': '1',
        'date': '2023-10-10T00:00:00.000Z',
        'note': 'First appointment',
        'purpose': 'Vaccination',
        'children': {
          'id': '1',
          'name': 'First child',
        },
        'profiles': {
          'user_id': '12',
          'mother_name': 'Mom',
        },
      };

      final appointment = AppointmentModel.fromSeribase(map);

      expect(appointment.id, '1');
      expect(appointment.date, DateTime.parse('2023-10-10T00:00:00.000Z'));
      expect(appointment.note, 'First appointment');
      expect(appointment.purpose, 'Vaccination');
      expect(appointment.child!.id, '1');
      expect(appointment.child!.nama, 'First child');
      expect(appointment.parent!.uid, '12');
      expect(appointment.parent!.momName, 'Mom');
    });

    test('fromSeribase creates an instance from a valid map with null children and profiles', () {
      final map = {
        'id': '1',
        'date': '2023-10-10T00:00:00.000Z',
        'note': 'First appointment',
        'purpose': 'Vaccination',
      };

      final appointment = AppointmentModel.fromSeribase(map);

      expect(appointment.id, '1');
      expect(appointment.date, DateTime.parse('2023-10-10T00:00:00.000Z'));
      expect(appointment.note, 'First appointment');
      expect(appointment.purpose, 'Vaccination');
    });

    test('fromSeribase returns null for invalid date format', () {
      final map = {
        'id': '1',
        'date': 'invalid-date',
        'note': 'First appointment',
        'purpose': 'Vaccination',
      };

      final appointment = AppointmentModel.fromSeribase(map);

      expect(appointment.id, '1');
      expect(appointment.date, isNull);
      expect(appointment.note, 'First appointment');
      expect(appointment.purpose, 'Vaccination');
    });

    test('toSeribase returns a valid map', () {
      final appointment = AppointmentModel(
        id: '1',
        date: DateTime.parse('2023-10-10T00:00:00.000Z'),
        note: 'First appointment',
        purpose: 'Vaccination',
      );

      final map = appointment.toSeribase();

      expect(map['date'], '2023-10-10T00:00:00.000Z');
      expect(map['note'], 'First appointment');
      expect(map['purpose'], 'Vaccination');
    });

    test('toSeribase omits null values', () {
      final appointment = AppointmentModel(
        id: '1',
        date: null,
        note: 'First appointment',
        purpose: null,
      );

      final map = appointment.toSeribase();

      expect(map.containsKey('date'), isFalse);
      expect(map['note'], 'First appointment');
      expect(map.containsKey('purpose'), isFalse);
    });

    test('copyWith no changes returns the same instance', () {
      final child = MockAnak();
      final parent = MockUsers();
      final healthWorker = MockHealthWorkerModel();

      final appointment = AppointmentModel(
        id: '1',
        child: child,
        date: DateTime.parse('2023-10-10T00:00:00.000Z'),
        note: 'First appointment',
        parent: parent,
        healthWorker: healthWorker,
        purpose: 'Vaccination',
      );

      final copy = appointment.copyWith();

      expect(copy, appointment);
    });

    test('copyWith change all attributes creates a copy of the instance', () {
      final child = MockAnak();
      final parent = MockUsers();
      final healthWorker = MockHealthWorkerModel();

      final appointment = AppointmentModel(
        id: '1',
        child: child,
        date: DateTime.parse('2023-10-10T00:00:00.000Z'),
        note: 'First appointment',
        parent: parent,
        healthWorker: healthWorker,
        purpose: 'Vaccination',
      );

      final copy = appointment.copyWith(
        id: '2',
        child: child.copyWith(nama: 'Second child'),
        parent: parent.copyWith(momName: 'Second parent'),
        healthWorker: healthWorker,
        date: DateTime.parse('2023-10-11T00:00:00.000Z'),
        note: 'Second appointment',
        purpose: 'Checkup',
      );

      expect(copy.id, '2');
      expect(copy.date, DateTime.parse('2023-10-11T00:00:00.000Z'));
      expect(copy.note, 'Second appointment');
      expect(copy.purpose, 'Checkup');
    });
  });
}
