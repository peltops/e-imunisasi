import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eimunisasi/features/authentication/data/models/user.dart';
import 'package:eimunisasi/features/profile/data/models/anak.dart';
import 'package:eimunisasi/features/profile/data/repositories/child_repository.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:mock_exceptions/mock_exceptions.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

@GenerateMocks([
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  DocumentSnapshot,
  Query,
  QuerySnapshot,
  Reference,
  TaskSnapshot,
], customMocks: [
  MockSpec<QueryDocumentSnapshot>(
    as: #MockQueryDocumentSnapshot,
    unsupportedMembers: {
      #data,
    },
  ),
])
@GenerateNiceMocks([
  MockSpec<UserCredential>(),
  MockSpec<Users>(),
  MockSpec<File>(),
  MockSpec<UploadTask>(),
])
import 'child_repository_test.mocks.dart';

void main() {
  group('getAllChildren', () {
    late FirebaseAuth firebaseAuth;
    late FirebaseFirestore firestore;
    late FirebaseStorage firebaseStorage;
    late ChildRepository childRepository;
    late MockUser mockUser;
    late Anak mockAnak;

    late CollectionReference<Map<String, dynamic>> collectionReference;
    late Query<Map<String, dynamic>> query;
    late QuerySnapshot<Map<String, dynamic>> querySnapshot;
    late QueryDocumentSnapshot<Map<String, dynamic>> queryDocumentSnapshot;
    late List<QueryDocumentSnapshot<Map<String, dynamic>>>
        listQueryDocumentSnapshot;

    final idMock = '1';

    setUp(() {
      mockUser = MockUser();
      mockAnak = Anak(
        id: idMock,
      );
      firebaseAuth = MockFirebaseAuth(mockUser: mockUser, signedIn: true);
      firestore = MockFirebaseFirestore();
      firebaseStorage = MockFirebaseStorage();
      childRepository = ChildRepository(
        firestore,
        firebaseAuth,
        firebaseStorage,
      );

      collectionReference = MockCollectionReference();
      query = MockQuery();
      querySnapshot = MockQuerySnapshot();
      queryDocumentSnapshot = MockQueryDocumentSnapshot();
      listQueryDocumentSnapshot = [queryDocumentSnapshot];
    });
    test(
        'getAllChildren returns a list of Anak if the call to firestore succeeds',
        () async {
      when(
        firestore.collection('children'),
      ).thenAnswer((_) => collectionReference);
      when(collectionReference.where('parent_id', isEqualTo: mockUser.uid))
          .thenReturn(query);
      when(query.get()).thenAnswer((_) async => querySnapshot);
      when(querySnapshot.docs).thenReturn(listQueryDocumentSnapshot);
      when(queryDocumentSnapshot.id).thenReturn(idMock);
      when(queryDocumentSnapshot.data()).thenReturn(mockAnak.toMap());

      final res = await childRepository.getAllChildren();
      expect(res, isA<List<Anak>>());
    });

    test(
        'getAllChildren throws an exception if the call to firestore unsucceeds',
        () async {
      when(
        firestore.collection('children'),
      ).thenAnswer((_) => collectionReference);
      when(collectionReference.where('parent_id', isEqualTo: mockUser.uid))
          .thenReturn(query);
      when(query.get()).thenThrow(Exception());

      expect(() => childRepository.getAllChildren(), throwsException);
    });
  });

  group('setChild', () {
    late FirebaseAuth firebaseAuth;
    late FirebaseFirestore firestore;
    late FirebaseStorage firebaseStorage;
    late ChildRepository childRepository;
    late MockUser mockUser;
    late Anak mockAnak;

    final idMock = '1';

    setUp(() {
      mockUser = MockUser();
      mockAnak = Anak(
        id: idMock,
      );
      firebaseAuth = MockFirebaseAuth(mockUser: mockUser, signedIn: true);
      firestore = FakeFirebaseFirestore();
      firebaseStorage = MockFirebaseStorage();
      childRepository = ChildRepository(
        firestore,
        firebaseAuth,
        firebaseStorage,
      );
    });
    test('setChild returns a Anak if the call to firestore succeeds', () async {
      final res = await childRepository.setChild(mockAnak);
      expect(res, isA<Anak>());
    });

    test('setChild throws an exception if the call to firestore unsucceeds',
        () async {
      final doc = firestore.collection('children');
      whenCalling(Invocation.method(#add, [mockAnak.toMap()]))
          .on(doc)
          .thenThrow(FirebaseException(plugin: 'firestore'));
      expect(
        () => doc.add(mockAnak.toMap()),
        throwsA(isA<FirebaseException>()),
      );
    });
  });

  group('updateChild', () {
    late FirebaseAuth firebaseAuth;
    late FirebaseFirestore firestore;
    late FirebaseStorage firebaseStorage;
    late ChildRepository childRepository;
    late MockUser mockUser;
    late Anak mockAnak;

    final idMock = '1';

    setUp(() {
      mockUser = MockUser();
      mockAnak = Anak(
        id: idMock,
      );
      firebaseAuth = MockFirebaseAuth(mockUser: mockUser, signedIn: true);
      firestore = FakeFirebaseFirestore();
      firebaseStorage = MockFirebaseStorage();
      childRepository = ChildRepository(
        firestore,
        firebaseAuth,
        firebaseStorage,
      );
    });
    test('updateChild returns a Anak if the call to firestore succeeds',
        () async {
      expect(
        () async => await childRepository.updateChild(mockAnak),
        isA<void>(),
      );
    });

    test('updateChild throws an exception if the call to firestore unsucceeds',
        () async {
      final doc = firestore.collection('children').doc(idMock);
      whenCalling(Invocation.method(#update, [mockAnak.toMap()]))
          .on(doc)
          .thenThrow(FirebaseException(plugin: 'firestore'));
      expect(
        () => childRepository.updateChild(mockAnak),
        throwsA(isA<FirebaseException>()),
      );
    });
  });

  group('deleteChild', () {
    late FirebaseAuth firebaseAuth;
    late FirebaseFirestore firestore;
    late FirebaseStorage firebaseStorage;
    late ChildRepository childRepository;
    late MockUser mockUser;
    late Anak mockAnak;

    final idMock = '1';

    setUp(() {
      mockUser = MockUser();
      mockAnak = Anak(
        id: idMock,
      );
      firebaseAuth = MockFirebaseAuth(mockUser: mockUser, signedIn: true);
      firestore = FakeFirebaseFirestore();
      firebaseStorage = MockFirebaseStorage();
      childRepository = ChildRepository(
        firestore,
        firebaseAuth,
        firebaseStorage,
      );
    });

    test('deleteChild returns a Anak if the call to firestore succeeds',
        () async {
      expect(
        () async => await childRepository.deleteChild(idMock),
        isA<void>(),
      );
    });

    test('deleteChild throws an exception if the call to firestore unsucceeds',
        () async {
      final doc = firestore.collection('children').doc(mockAnak.id);
      whenCalling(Invocation.method(#delete, null))
          .on(doc)
          .thenThrow(FirebaseException(plugin: 'firestore'));
      expect(
        () => childRepository.deleteChild(idMock),
        throwsA(isA<FirebaseException>()),
      );
    });
  });

  group('updateChildAvatar', () {
    late FirebaseAuth firebaseAuth;
    late FirebaseFirestore firestore;
    late FirebaseStorage firebaseStorage;
    late ChildRepository childRepository;
    late MockUser mockUser;
    late Anak mockAnak;

    late File mockFile;
    final idMock = '1';

    setUp(() {
      mockUser = MockUser();
      mockAnak = Anak(
        id: idMock,
      );
      mockFile = MockFile();
      firebaseAuth = MockFirebaseAuth(mockUser: mockUser, signedIn: true);
      firestore = FakeFirebaseFirestore();
      firebaseStorage = MockFirebaseStorage();
      childRepository = ChildRepository(
        firestore,
        firebaseAuth,
        firebaseStorage,
      );
    });

    test('updateChildAvatar returns a Anak if the call to firestore succeeds',
            () async {
          expect(
                () async => await childRepository.updateChildAvatar(
              file: mockFile,
              id: idMock,
            ),
            isA<void>(),
          );
        });

    test(
        'updateChildAvatar throws an exception if the call to firestore unsucceeds',
            () async {
          final doc = firestore.collection('children').doc(idMock);
          whenCalling(Invocation.method(#update, [mockAnak.toMap()]))
              .on(doc)
              .thenThrow(FirebaseException(plugin: 'firestore'));
          expect(
                () => doc.update(mockAnak.toMap()),
            throwsA(isA<FirebaseException>()),
          );
        });
  });

  group('throw Exeption when User not logged in', () {
    late FirebaseAuth firebaseAuth;
    late FirebaseFirestore firestore;
    late FirebaseStorage firebaseStorage;
    late ChildRepository childRepository;
    late MockUser mockUser;

    setUp(() {
      mockUser = MockUser();
      firebaseAuth = MockFirebaseAuth(mockUser: mockUser, signedIn: false);
      firestore = FakeFirebaseFirestore();
      firebaseStorage = MockFirebaseStorage();
      childRepository = ChildRepository(
        firestore,
        firebaseAuth,
        firebaseStorage,
      );
    });
    test('getAllChildren throws an exception if the call to firebaseAuth not logged in',
        () async {
      expect(() => childRepository.getAllChildren(), throwsException);
    });

    test('setChild throws an exception if the call to firebaseAuth not logged in',
        () async {
      expect(() => childRepository.setChild(Anak()), throwsException);
    });

    test('updateChild throws an exception if the call to firebaseAuth not logged in',
        () async {
      expect(() => childRepository.updateChild(Anak()), throwsException);
    });

    test('deleteChild throws an exception if the call to firebaseAuth not logged in',
        () async {
      expect(() => childRepository.deleteChild(''), throwsException);
    });

    test('updateChildAvatar throws an exception if the call to firebaseAuth not logged in',
        () async {
      expect(() => childRepository.updateChildAvatar(file: MockFile(), id: ''), throwsException);
    });

  });
}
