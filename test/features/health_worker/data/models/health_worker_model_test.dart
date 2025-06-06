import 'package:eimunisasi/features/health_worker/data/models/clinic_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eimunisasi/features/health_worker/data/models/health_worker_model.dart';

void main() {
  group('HealthWorkerModel', () {
    group('fromSeribase', () {
      test('creates an instance from a valid map', () {
        final map = {
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
              'day': {
                'id': 1,
                'name': 'Senin',
              },
              'start_time': '12:00:00',
              'end_time': '14:00:00'
            }
          ],
          'practice_schedules': [
            {
              'day': {
                'id': 2,
                'name': 'Selasa',
              },
              'start_time': '10:00:00',
              'end_time': '12:00:00'
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

        final healthWorker = HealthWorkerModel.fromSeribase(map);

        expect(healthWorker.id, '1');
        expect(healthWorker.clinic?.name, 'Clinic Name');
        expect(healthWorker.email, 'test@example.com');
        expect(healthWorker.schedules?.first.day?.name, 'Senin');
        expect(healthWorker.practiceSchedules?.first.day?.name, 'Selasa');
        expect(healthWorker.kartuKeluarga, '1234567890');
        expect(healthWorker.fullName, 'John Doe');
        expect(healthWorker.nik, '9876543210');
        expect(healthWorker.phoneNumber, '0987654321');
        expect(healthWorker.photoURL, 'http://example.com/photo.jpg');
        expect(healthWorker.profession, 'Doctor');
        expect(healthWorker.date_of_birth,
            DateTime.parse('1980-01-01T00:00:00.000Z'));
        expect(healthWorker.place_of_date, 'City');
      });

      test('returns null for invalid date format', () {
        final map = {
          'id': '1',
          'date_of_birth': 'invalid-date',
        };

        final healthWorker = HealthWorkerModel.fromSeribase(map);

        expect(healthWorker.date_of_birth, isNull);
      });

      test('return empty list for error parse schedule', () {
        final map = {
          'id': '1',
          'schedule': {
            'day': 'Monday',
            'start_time': '2023-10-10T08:00:00.000Z',
            'end_time': '2023-10-10T12:00:00.000Z'
          }
        };

        final healthWorker = HealthWorkerModel.fromSeribase(map);

        expect(healthWorker.schedules, List<Schedule>.empty());
      });

      test('return empty list for error parse practiceSchedule', () {
        final map = {
          'id': '1',
          'practice_schedules': {
            'day': 'Monday',
            'start_time': '2023-10-10T08:00:00.000Z',
            'end_time': '2023-10-10T12:00:00.000Z'
          }
        };

        final healthWorker = HealthWorkerModel.fromSeribase(map);

        expect(healthWorker.practiceSchedules, List<Schedule>.empty());
      });
    });

    group('toSeribase', () {
      test('returns a valid map', () {
        final dateNow = DateTime.now();
        final dateString = dateNow.toIso8601String();
        final healthWorker = HealthWorkerModel(
          id: '1',
          clinic: ClinicModel(
            id: '1',
            name: 'Clinic Name',
            address: '123 Street',
            motto: 'Health First',
            phoneNumber: '1234567890',
            photos: ['photo1.jpg', 'photo2.jpg'],
          ),
          email: 'test@example.com',
          schedules: [
            Schedule(
              day: Day(
                id: 1,
                name: 'Senin',
              ),
              startTime: '08:23:45',
              endTime: '12:23:45',
            )
          ],
          practiceSchedules: [
            Schedule(
              day: Day(
                id: 2,
                name: 'Selasa',
              ),
              startTime: '08:23:45',
              endTime: '12:23:45',
            )
          ],
          kartuKeluarga: '1234567890',
          fullName: 'John Doe',
          nik: '9876543210',
          phoneNumber: '0987654321',
          photoURL: 'http://example.com/photo.jpg',
          profession: 'Doctor',
          date_of_birth: DateTime.parse(dateString),
          place_of_date: 'City',
        );

        final map = healthWorker.toSeribase();

        expect(map['id'], '1');
        expect(map['clinic']['name'], 'Clinic Name');
        expect(map['email'], 'test@example.com');
        expect(map['schedule'].first['day_id'], 1);
        expect(map['practice_schedules'].first['day_id'], 2);
        expect(map['no_kartu_keluarga'], '1234567890');
        expect(map['full_name'], 'John Doe');
        expect(map['no_induk_kependudukan'], '9876543210');
        expect(map['phone_number'], '0987654321');
        expect(map['avatar_url'], 'http://example.com/photo.jpg');
        expect(map['profession'], 'Doctor');
        expect(map['date_of_birth'], dateString);
        expect(map['place_of_birth'], 'City');
      });

      test('omits null values', () {
        final healthWorker = HealthWorkerModel(
          id: '1',
          clinic: null,
          email: 'test@example.com',
          schedules: null,
          practiceSchedules: null,
          kartuKeluarga: '1234567890',
          fullName: 'John Doe',
          nik: '9876543210',
          phoneNumber: '0987654321',
          photoURL: 'http://example.com/photo.jpg',
          profession: 'Doctor',
          date_of_birth: DateTime.parse('1980-01-01T00:00:00.000Z'),
          place_of_date: null,
        );

        final map = healthWorker.toSeribase();

        expect(map.containsKey('clinic'), isFalse);
        expect(map.containsKey('schedule'), isFalse);
        expect(map.containsKey('practice_schedules'), isFalse);
        expect(map.containsKey('place_of_birth'), isFalse);
      });
    });

    group('props', () {
      test('returns correct props', () {
        final dateString = '1980-01-01T00:00:00.000Z';
        final healthWorker = HealthWorkerModel(
          id: '1',
          clinic: ClinicModel(
            id: '1',
            name: 'Clinic Name',
            address: '123 Street',
            motto: 'Health First',
            phoneNumber: '1234567890',
            photos: ['photo1.jpg', 'photo2.jpg'],
          ),
          email: 'test@example.com',
          schedules: [
            Schedule(
              day: Day(
                id: 1,
                name: 'Senin',
              ),
              startTime: '08:23:45',
              endTime: '12:23:45',
            )
          ],
          practiceSchedules: [
            Schedule(
              day: Day(
                id: 2,
                name: 'Selasa',
              ),
              startTime: '08:23:45',
              endTime: '12:23:45',
            )
          ],
          kartuKeluarga: '1234567890',
          fullName: 'John Doe',
          nik: '9876543210',
          phoneNumber: '0987654321',
          photoURL: 'http://example.com/photo.jpg',
          profession: 'Doctor',
          date_of_birth: DateTime.parse(dateString),
          place_of_date: 'City',
          bookingFee: '100'
        );

        expect(healthWorker.props, [
          '1',
          healthWorker.clinic,
          healthWorker.email,
          healthWorker.schedules,
          healthWorker.practiceSchedules,
          '1234567890',
          'John Doe',
          '9876543210',
          '0987654321',
          'http://example.com/photo.jpg',
          'Doctor',
          DateTime.parse(dateString),
          'City',
          '100'
        ]);
      });
    });

    group('schedule model', () {
      test('returns combine start time and end time with get time', () {
        final schedule = Schedule(
          day: Day(
            id: 1,
            name: 'Senin',
          ),
          startTime: '08:23:45',
          endTime: '12:23:45',
        );

        expect(schedule.time, '08:23 - 12:23');
      });

      test('returns emptyString when start time and end time null with get time', () {
        final schedule = Schedule(
          day: Day(
            id: 1,
            name: 'Senin',
          ),
        );

        expect(schedule.time, '');
      });
      test('returns correct props', () {
        final schedule = Schedule(
          day: Day(
            id: 1,
            name: 'Senin',
          ),
          startTime: '08:23:45',
          endTime: '12:23:45',
        );

        expect(schedule.props, [
          schedule.day,
          '08:23:45',
          '12:23:45',
        ]);
      });
    });

    group('day model', () {
      test('toSeribase returns a valid map', () {
        final day = Day(
          id: 1,
          name: 'Senin',
        );

        final map = day.toSeribase();

        expect(map['id'], 1);
        expect(map['name'], 'Senin');
      });
      test('returns correct props', () {
        final day = Day(
          id: 1,
          name: 'Senin',
        );

        expect(day.props, [
          1,
          'Senin',
        ]);
      });
    });
  });
}
