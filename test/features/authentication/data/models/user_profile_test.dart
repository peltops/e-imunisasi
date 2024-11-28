import 'package:test/test.dart';
import 'package:eimunisasi/features/authentication/data/models/user_profile.dart';

void main() {
    group('UserProfile', () {
        group('fromSeribase', () {
            test('creates UserProfile from valid data', () {
                final data = {
                    'user_id': '1',
                    'email': 'test@example.com',
                    'mother_name': 'Jane',
                    'father_name': 'John',
                    'father_phone_number': '1234567890',
                    'mother_phone_number': '0987654321',
                    'father_blood_type': 'A',
                    'mother_blood_type': 'B',
                    'father_job': 'Engineer',
                    'mother_job': 'Doctor',
                    'address': '123 Street',
                    'avatar_url': 'http://example.com/avatar.jpg',
                    'verified': true,
                    'place_of_birth': 'City',
                    'date_of_birth': '2022-01-01',
                    'no_kartu_keluarga': '123456789',
                    'no_induk_kependudukan': '987654321',
                };
                final userProfile = UserProfile.fromSeribase(data);
                expect(userProfile.uid, '1');
                expect(userProfile.email, 'test@example.com');
                expect(userProfile.momName, 'Jane');
                expect(userProfile.dadName, 'John');
                expect(userProfile.dadPhoneNumber, '1234567890');
                expect(userProfile.momPhoneNumber, '0987654321');
                expect(userProfile.dadBloodType, 'A');
                expect(userProfile.momBloodType, 'B');
                expect(userProfile.dadJob, 'Engineer');
                expect(userProfile.momJob, 'Doctor');
                expect(userProfile.address, '123 Street');
                expect(userProfile.avatarURL, 'http://example.com/avatar.jpg');
                expect(userProfile.verified, true);
                expect(userProfile.placeOfBirth, 'City');
                expect(userProfile.dateOfBirth, DateTime.parse('2022-01-01'));
                expect(userProfile.noKK, '123456789');
                expect(userProfile.noKTP, '987654321');
            });

            test('creates UserProfile with null dateOfBirth when date_of_birth is invalid', () {
                final data = {
                    'date_of_birth': 'invalid-date',
                };
                final userProfile = UserProfile.fromSeribase(data);
                expect(userProfile.dateOfBirth, null);
            });
        });

        group('toSeribaseMap', () {
            test('returns correct map representation of UserProfile', () {
                final userProfile = UserProfile(
                    uid: '1',
                    email: 'test@example.com',
                    momName: 'Jane',
                    dadName: 'John',
                    dadPhoneNumber: '1234567890',
                    momPhoneNumber: '0987654321',
                    dadBloodType: 'A',
                    momBloodType: 'B',
                    dadJob: 'Engineer',
                    momJob: 'Doctor',
                    address: '123 Street',
                    avatarURL: 'http://example.com/avatar.jpg',
                    verified: true,
                    placeOfBirth: 'City',
                    dateOfBirth: DateTime.parse('2022-01-01'),
                    noKK: '123456789',
                    noKTP: '987654321',
                );
                final map = userProfile.toSeribaseMap();
                expect(map['user_id'], '1');
                expect(map['email'], null);
                expect(map['mother_name'], 'Jane');
                expect(map['father_name'], 'John');
                expect(map['father_phone_number'], '1234567890');
                expect(map['mother_phone_number'], '0987654321');
                expect(map['father_blood_type'], 'A');
                expect(map['mother_blood_type'], 'B');
                expect(map['father_job'], 'Engineer');
                expect(map['mother_job'], 'Doctor');
                expect(map['address'], '123 Street');
                expect(map['avatar_url'], 'http://example.com/avatar.jpg');
                expect(map['place_of_birth'], 'City');
                expect(map['date_of_birth'], '2022-01-01T00:00:00.000');
                expect(map['no_kartu_keluarga'], '123456789');
                expect(map['no_induk_kependudukan'], '987654321');
            });

            test('excludes null and empty fields from map representation', () {
                final userProfile = UserProfile(
                    uid: '1',
                    email: '',
                    momName: '',
                    dadName: '',
                    dadPhoneNumber: '',
                    momPhoneNumber: '',
                    dadBloodType: '',
                    momBloodType: '',
                    dadJob: '',
                    momJob: '',
                    address: '',
                    avatarURL: '',
                    verified: false,
                    placeOfBirth: '',
                    dateOfBirth: null,
                    noKK: '',
                    noKTP: '',
                );
                final map = userProfile.toSeribaseMap();
                expect(map.containsKey('email'), false);
                expect(map.containsKey('mother_name'), false);
                expect(map.containsKey('father_name'), false);
                expect(map.containsKey('father_phone_number'), false);
                expect(map.containsKey('mother_phone_number'), false);
                expect(map.containsKey('father_blood_type'), false);
                expect(map.containsKey('mother_blood_type'), false);
                expect(map.containsKey('father_job'), false);
                expect(map.containsKey('mother_job'), false);
                expect(map.containsKey('address'), false);
                expect(map.containsKey('avatar_url'), false);
                expect(map.containsKey('place_of_birth'), false);
                expect(map.containsKey('date_of_birth'), false);
                expect(map.containsKey('no_kartu_keluarga'), false);
                expect(map.containsKey('no_induk_kependudukan'), false);
            });
        });

        group('copyWith', () {
            test('returns a copy with updated fields', () {
                final userProfile = UserProfile(
                    uid: '1',
                    email: 'test@example.com',
                    momName: 'Jane',
                    dadName: 'John',
                    dadPhoneNumber: '1234567890',
                    momPhoneNumber: '0987654321',
                    dadBloodType: 'A',
                    momBloodType: 'B',
                    dadJob: 'Engineer',
                    momJob: 'Doctor',
                    address: '123 Street',
                    avatarURL: 'http://example.com/avatar.jpg',
                    verified: true,
                    placeOfBirth: 'City',
                    dateOfBirth: DateTime.parse('2022-01-01'),
                    noKK: '123456789',
                    noKTP: '987654321',
                );
                final updatedUserProfile = userProfile.copyWith(email: 'new@example.com', momName: 'Janet');
                expect(updatedUserProfile.email, 'new@example.com');
                expect(updatedUserProfile.momName, 'Janet');
                expect(updatedUserProfile.dadName, 'John');
            });

            test('returns a copy with unchanged fields when no new values are provided', () {
                final userProfile = UserProfile(
                    uid: '1',
                    email: 'test@example.com',
                    momName: 'Jane',
                    dadName: 'John',
                    dadPhoneNumber: '1234567890',
                    momPhoneNumber: '0987654321',
                    dadBloodType: 'A',
                    momBloodType: 'B',
                    dadJob: 'Engineer',
                    momJob: 'Doctor',
                    address: '123 Street',
                    avatarURL: 'http://example.com/avatar.jpg',
                    verified: true,
                    placeOfBirth: 'City',
                    dateOfBirth: DateTime.parse('2022-01-01'),
                    noKK: '123456789',
                    noKTP: '987654321',
                );
                final updatedUserProfile = userProfile.copyWith();
                expect(updatedUserProfile, equals(userProfile));
                expect(updatedUserProfile.email, 'test@example.com');
                expect(updatedUserProfile.momName, 'Jane');
                expect(updatedUserProfile.dadName, 'John');
            });
        });
    });
}