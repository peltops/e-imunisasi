import 'package:test/test.dart';
import 'package:eimunisasi/features/profile/data/models/child_model.dart';

void main() {
  group('ChildModel', () {
    group('umurAnak', () {
      test('returns correct age in years and months when tanggalLahir is provided', () {
        final child = ChildModel(tanggalLahir: DateTime.now().subtract(Duration(days: 400)));
        expect(child.umurAnak, '1 tahun, 1 bulan');
      });

      test('returns "Umur belum diisi" when tanggalLahir is null', () {
        final child = ChildModel(tanggalLahir: null);
        expect(child.umurAnak, 'Umur belum diisi');
      });
    });

    group('fromSeribase', () {
      test('creates ChildModel from valid data', () {
        final data = {
          'id': '1',
          'parent_id': '2',
          'name': 'John',
          'nik': '123456',
          'place_of_birth': 'City',
          'date_of_birth': '2022-01-01',
          'gender': 'Male',
          'blood_type': 'O',
          'avatar_url': 'http://example.com/photo.jpg',
        };
        final child = ChildModel.fromSeribase(data);
        expect(child.id, '1');
        expect(child.parentId, '2');
        expect(child.nama, 'John');
        expect(child.nik, '123456');
        expect(child.tempatLahir, 'City');
        expect(child.tanggalLahir, DateTime.parse('2022-01-01'));
        expect(child.jenisKelamin, 'Male');
        expect(child.golDarah, 'O');
        expect(child.photoURL, 'http://example.com/photo.jpg');
      });

      test('creates ChildModel with null tanggalLahir when date_of_birth is invalid', () {
        final data = {
          'date_of_birth': 'invalid-date',
        };
        final child = ChildModel.fromSeribase(data);
        expect(child.tanggalLahir, null);
      });
    });

    group('toSeribaseMap', () {
      test('returns correct map representation of ChildModel', () {
        final child = ChildModel(
          id: '1',
          parentId: '2',
          nama: 'John',
          nik: '123456',
          tempatLahir: 'City',
          tanggalLahir: DateTime.parse('2022-01-01'),
          jenisKelamin: 'Male',
          golDarah: 'O',
          photoURL: 'http://example.com/photo.jpg',
        );
        final map = child.toSeribaseMap();
        expect(map['parent_id'], '2');
        expect(map['name'], 'John');
        expect(map['nik'], '123456');
        expect(map['place_of_birth'], 'City');
        expect(map['date_of_birth'], '2022-01-01T00:00:00.000');
        expect(map['gender'], 'Male');
        expect(map['blood_type'], 'O');
        expect(map['avatar_url'], 'http://example.com/photo.jpg');
      });

      test('excludes null and empty fields from map representation', () {
        final child = ChildModel(
          id: '1',
          parentId: '',
          nama: '',
          nik: '',
          tempatLahir: '',
          tanggalLahir: null,
          jenisKelamin: '',
          golDarah: '',
          photoURL: '',
        );
        final map = child.toSeribaseMap();
        expect(map.containsKey('parent_id'), false);
        expect(map.containsKey('name'), false);
        expect(map.containsKey('nik'), false);
        expect(map.containsKey('place_of_birth'), false);
        expect(map.containsKey('date_of_birth'), false);
        expect(map.containsKey('gender'), false);
        expect(map.containsKey('blood_type'), false);
        expect(map.containsKey('avatar_url'), false);
      });
    });

    group('copyWith', () {
      test('returns a copy with updated fields', () {
        final child = ChildModel(
          id: '1',
          parentId: '2',
          nama: 'John',
          nik: '123456',
          tempatLahir: 'City',
          tanggalLahir: DateTime.parse('2022-01-01'),
          jenisKelamin: 'Male',
          golDarah: 'O',
          photoURL: 'http://example.com/photo.jpg',
        );
        final updatedChild = child.copyWith(nama: 'Jane', nik: '654321');
        expect(updatedChild.nama, 'Jane');
        expect(updatedChild.nik, '654321');
        expect(updatedChild.tempatLahir, 'City');
      });

      test('returns a copy with unchanged fields when no new values are provided', () {
        final child = ChildModel(
          id: '1',
          parentId: '2',
          nama: 'John',
          nik: '123456',
          tempatLahir: 'City',
          tanggalLahir: DateTime.parse('2022-01-01'),
          jenisKelamin: 'Male',
          golDarah: 'O',
          photoURL: 'http://example.com/photo.jpg',
        );
        final updatedChild = child.copyWith();
        expect(updatedChild, equals(child));
        expect(updatedChild.nama, 'John');
        expect(updatedChild.nik, '123456');
        expect(updatedChild.tempatLahir, 'City');
      });
    });
  });
}