import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eimunisasi/features/healthy_book/data/models/checkup_model.dart';
import 'package:eimunisasi/features/healthy_book/data/repositories/checkup_repository.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  DocumentSnapshot,
  Query,
  QuerySnapshot,
], customMocks: [
  MockSpec<QueryDocumentSnapshot>(
    as: #MockQueryDocumentSnapshot,
    unsupportedMembers: {
      #data,
    },
  ),
])
import 'checkup_repository_test.mocks.dart';

void main() {
  late CheckupRepository checkupRepository;
  late FirebaseFirestore firestore;

  setUp(() {
    firestore = MockFirebaseFirestore();
    checkupRepository = CheckupRepository(firestore);
  });

  group('getCheckups', () {
    test('returns a list of CheckupModel if the call to firestore succeeds',
        () async {
      final instance = FakeFirebaseFirestore();
      final checkupRepository = CheckupRepository(instance);
      final testCheckup = CheckupModel(
        beratBadan: 10,
        tinggiBadan: 10,
        lingkarKepala: 10,
        jenisVaksin: 'jenisVaksin',
        riwayatKeluhan: 'riwayatKeluhan',
        diagnosa: 'diagnosa',
        tindakan: 'tindakan',
        id: 'id',
        idOrangTuaPasien: 'idOrangTua',
        idPasien: 'idPasien',
        idDokter: 'idDokter',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        deletedAt: DateTime.now(),
      );

      await instance.collection('checkups').add(testCheckup.toMap());

      final res = await checkupRepository.getCheckups('idPasien');
      expect(res, isA<List<CheckupModel>>());
    });

    test('throws an exception if the call to firestore unsucceeds', () async {
      when(firestore.collection('checkups')).thenThrow(FirebaseException(
        plugin: 'plugin',
        message: 'message',
        code: 'code',
      ));
      expect(
        () => checkupRepository.getCheckups('idPasien'),
        throwsA(isA<FirebaseException>()),
      );
    });

    test('throws an exception if the call to firestore unsucceeds Unexpected Exception', () async {
      when(firestore.collection('checkups')).thenThrow(Exception(
        'message',
      ));
      expect(
        () => checkupRepository.getCheckups('idPasien'),
        throwsA(isA<Exception>()),
      );
    });
  });
}
