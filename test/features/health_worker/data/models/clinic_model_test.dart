import 'package:flutter_test/flutter_test.dart';
import 'package:eimunisasi/features/health_worker/data/models/clinic_model.dart';

void main() {
  group('ClinicModel', () {
    group('fromSeribase', () {
      test('creates an instance from a valid map', () {
        final map = {
          'id': '1',
          'name': 'Clinic Name',
          'address': '123 Street',
          'motto': 'Health First',
          'phone_number': '1234567890',
          'photos': ['photo1.jpg', 'photo2.jpg'],
        };

        final clinic = ClinicModel.fromSeribase(map);

        expect(clinic.id, '1');
        expect(clinic.name, 'Clinic Name');
        expect(clinic.address, '123 Street');
        expect(clinic.motto, 'Health First');
        expect(clinic.phoneNumber, '1234567890');
        expect(clinic.photos, ['photo1.jpg', 'photo2.jpg']);
      });

      test('returns null for invalid photos format', () {
        final map = {
          'id': '1',
          'name': 'Clinic Name',
          'address': '123 Street',
          'motto': 'Health First',
          'phone_number': '1234567890',
          'photos': 'invalid-photos-format',
        };

        final clinic = ClinicModel.fromSeribase(map);

        expect(clinic.photos, isNull);
      });
    });

    group('toSeribase', () {
      test('returns a valid map', () {
        final clinic = ClinicModel(
          id: '1',
          name: 'Clinic Name',
          address: '123 Street',
          motto: 'Health First',
          phoneNumber: '1234567890',
          photos: ['photo1.jpg', 'photo2.jpg'],
        );

        final map = clinic.toSeribase();

        expect(map['id'], '1');
        expect(map['name'], 'Clinic Name');
        expect(map['address'], '123 Street');
        expect(map['motto'], 'Health First');
        expect(map['phone_number'], '1234567890');
        expect(map['photos'], ['photo1.jpg', 'photo2.jpg']);
      });

      test('omits null values', () {
        final clinic = ClinicModel(
          id: '1',
          name: 'Clinic Name',
          address: '123 Street',
          motto: null,
          phoneNumber: '1234567890',
          photos: null,
        );

        final map = clinic.toSeribase();

        expect(map.containsKey('motto'), isFalse);
        expect(map.containsKey('photos'), isFalse);
      });
    });

    group('props', () {
      test('returns correct props', () {
        final clinic = ClinicModel(
          id: '1',
          name: 'Clinic Name',
          address: '123 Street',
          motto: 'Health First',
          phoneNumber: '1234567890',
          photos: ['photo1.jpg', 'photo2.jpg'],
        );

        expect(clinic.props, [
          '1',
          'Clinic Name',
          '123 Street',
          'Health First',
          '1234567890',
          ['photo1.jpg', 'photo2.jpg'],
        ]);
      });
    });
  });
}