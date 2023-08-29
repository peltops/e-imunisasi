import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eimunisasi/features/authentication/data/models/user.dart';
import 'package:eimunisasi/utils/string_extension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:mock_exceptions/mock_exceptions.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';
import 'package:eimunisasi/features/authentication/data/repositories/auth_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

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
  MockSpec<SharedPreferences>(),
])
import 'auth_repository_test.mocks.dart';

void main() {
  late FirebaseAuth firebaseAuth;
  late FirebaseFirestore firestore;
  late FirebaseStorage firebaseStorage;
  late SharedPreferences sharedPreferences;
  late AuthRepository authRepository;
  late MockUser mockUser;

  setUp(() {
    mockUser = MockUser(
      isAnonymous: false,
      uid: '12345',
      email: 'contoh@cth.com',
      isEmailVerified: true,
      displayName: 'contoh',
      phoneNumber: '+6281234567890',
      photoURL: 'url',
    );
    firebaseAuth = MockFirebaseAuth(mockUser: mockUser, signedIn: true);
    firestore = MockFirebaseFirestore();
    firebaseStorage = MockFirebaseStorage();
    sharedPreferences = MockSharedPreferences();
    authRepository = AuthRepository(
      firestore,
      firebaseAuth,
      firebaseStorage,
      sharedPreferences,
    );
  });

  group('logInWithEmailAndPassword', () {
    late String email;
    late String password;

    setUp(() {
      email = 'example@ex.com';
      password = '123456';
    });
    test(
        'logInWithEmailAndPassword calls signInWithEmailAndPassword with correct arguments',
        () async {
      final res = await authRepository.logInWithEmailAndPassword(
        email: email,
        password: password,
      );
      expect(res, isA<UserCredential>());
    });
    test(
        'logInWithEmailAndPassword throws an exception if signInWithEmailAndPassword throws',
        () async {
      whenCalling(Invocation.method(#signInWithEmailAndPassword, null))
          .on(firebaseAuth)
          .thenThrow(FirebaseAuthException(code: 'ERROR_INVALID_EMAIL'));
      expect(
        () => authRepository.logInWithEmailAndPassword(
            email: email, password: password),
        throwsA(isA<FirebaseAuthException>()),
      );
    });
  });

  group('forgetEmailPassword', () {
    late String email;

    setUp(() {
      email = 'example@ex.com';
    });
    test(
        'forgetEmailPassword calls sendPasswordResetEmail with correct arguments',
        () async {
      final res = authRepository.forgetEmailPassword(email: email);
      expect(
        res,
        isA<Future<void>>(),
      );
    });
    test(
        'forgetEmailPassword throws an exception if sendPasswordResetEmail throws',
        () async {
      whenCalling(Invocation.method(#sendPasswordResetEmail, null))
          .on(firebaseAuth)
          .thenThrow(FirebaseAuthException(code: 'invalid-email'));

      expect(
        () => authRepository.forgetEmailPassword(email: email),
        throwsA(isA<FirebaseAuthException>()),
      );
    });
  });

  group('verifyPhoneNumber', () {
    late String phone;
    late void Function(String, int?) codeSent;
    late void Function(FirebaseAuthException) verificationFailed;
    late void Function(PhoneAuthCredential) verificationCompleted;

    setUp(() {
      phone = '+6281234567890';
      codeSent = (String verificationId, int? forceResendingToken) {};
      verificationFailed = (FirebaseAuthException e) {};
      verificationCompleted = (PhoneAuthCredential credential) {};
    });
    test('verifyPhoneNumber calls verifyPhoneNumber with correct arguments',
        () async {
      final result = authRepository.verifyPhoneNumber(
        phone: phone,
        codeSent: codeSent,
        verificationFailed: verificationFailed,
        verificationCompleted: verificationCompleted,
      );

      expect(result, isA<Future<void>>());
    });
  });

  group('signInWithCredential', () {
    final verificationId = '123456';
    final smsCode = '123456';

    test(
        'signInWithCredential calls signInWithCredential with correct arguments',
        () async {
      final res = await authRepository.signInWithCredential(
        verificationId: verificationId,
        otp: smsCode,
      );
      expect(res, isA<UserCredential>());
    });
    test(
        'signInWithCredential throws an exception if signInWithCredential throws',
        () async {
      whenCalling(Invocation.method(#signInWithCredential, null))
          .on(firebaseAuth)
          .thenThrow(FirebaseAuthException(code: 'error'));
      expect(
        () => authRepository.signInWithCredential(
          verificationId: verificationId,
          otp: smsCode,
        ),
        throwsA(isA<FirebaseAuthException>()),
      );
    });
  });

  group('signUpWithEmailAndPassword', () {
    late String email;
    late String password;
    late UserCredential userCredential;

    setUp(() {
      email = 'example@example.com';
      password = '12331242';
      userCredential = MockUserCredential();
    });

    test('signUpWithEmailAndPassword success', () async {
      final result = await authRepository.signUpWithEmailAndPassword(
        email: email,
        password: password,
      );
      expect(result, isA<UserCredential>());
    });
    test(
      'signUpWithEmailAndPassword throws an exception if createUserWithEmailAndPassword throws',
      () async {
        whenCalling(Invocation.method(#createUserWithEmailAndPassword, null))
            .on(firebaseAuth)
            .thenThrow(FirebaseAuthException(code: 'invalid-email'));
        expect(
          () => authRepository.signUpWithEmailAndPassword(
            email: email,
            password: password,
          ),
          throwsA(isA<FirebaseAuthException>()),
        );
      },
    );
  });

  group('insertUserToDatabase', () {
    late Users user;
    late CollectionReference<Map<String, dynamic>> collectionReference;
    late DocumentReference<Map<String, dynamic>> documentReference;
    setUp(() {
      user = Users(
        uid: '123',
        email: 'ateaas@dafa.com',
        nomorhpIbu: '123123123',
        golDarahAyah: 'A',
        golDarahIbu: 'B',
        verified: true,
      );
      collectionReference = MockCollectionReference();
      documentReference = MockDocumentReference();
      when(firestore.collection('users')).thenReturn(collectionReference);
      when(collectionReference.doc(user.uid)).thenReturn(documentReference);
    });
    test('insertUserToDatabase success', () {
      when(documentReference.set(user.toJson()))
          .thenAnswer((_) => Future.value());
      final result = authRepository.insertUserToDatabase(user: user);
      verify(documentReference.set(user.toJson())).called(1);
      expect(result, isA<Future<void>>());
    });

    test('insertUserToDatabase throws an exception if set throws', () {
      when(documentReference.set(user.toJson()))
          .thenThrow(FirebaseAuthException(code: 'invalid-email'));

      expect(
        () => authRepository.insertUserToDatabase(user: user),
        throwsA(isA<FirebaseAuthException>()),
      );
    });
  });

  group('signOut', () {
    test('signOut success', () {
      final result = authRepository.signOut();
      expect(result, isA<Future<void>>());
    });

    test('signOut throws an exception if signOut throws', () async {
      whenCalling(Invocation.method(#signOut, null))
          .on(firebaseAuth)
          .thenThrow(Exception('error'));

      final result = authRepository.signOut();
      expect(
        result,
        isA<Future<void>>(),
      );
    });
  });

  group('isSignedIn', () {
    test('isSignedIn success', () async {
      final result = await authRepository.isSignedIn();
      expect(result, true);
    });

    test('isSignedIn returns false if currentUser is null', () async {
      final firebaseAuth = MockFirebaseAuth(signedIn: false);
      final authRepository = AuthRepository(
        firestore,
        firebaseAuth,
        firebaseStorage,
        sharedPreferences,
      );
      final result = await authRepository.isSignedIn();
      expect(result, false);
    });
  });

  group('getUser', () {
    late User user;
    late Users users;
    late CollectionReference<Map<String, dynamic>> collectionReference;
    late DocumentReference<Map<String, dynamic>> documentReference;
    late DocumentSnapshot<Map<String, dynamic>> documentSnapshot;

    setUp(() {
      users = MockUsers();
      collectionReference = MockCollectionReference();
      documentReference = MockDocumentReference();
      documentSnapshot = MockDocumentSnapshot();
      when(firestore.collection('users')).thenReturn(collectionReference);
      when(collectionReference.doc(firebaseAuth.currentUser?.uid))
          .thenReturn(documentReference);
    });

    test('getUser success', () async {
      when(documentReference.get()).thenAnswer(
        (_) => Future.value(documentSnapshot),
      );
      when(documentSnapshot.exists).thenReturn(true);
      when(documentSnapshot.data()).thenReturn(users.toJson());

      final result = await authRepository.getUser();
      verify(documentReference.get()).called(1);
      expect(result, isA<Users>());
    });

    test('getUser throws an exception if get throws', () async {
      when(documentReference.get())
          .thenThrow(FirebaseAuthException(code: 'invalid-email'));

      expect(
        () => authRepository.getUser(),
        throwsA(isA<FirebaseAuthException>()),
      );
    });

    test('getUser throws an exception if documentSnapshot does not exist',
        () async {
      when(documentReference.get()).thenAnswer(
        (_) => Future.value(documentSnapshot),
      );
      when(documentSnapshot.exists).thenReturn(false);

      final result = await authRepository.getUser();

      expect(
        result,
        null,
      );
    });
  });

  group('isPhoneNumberExist', () {
    late CollectionReference<Map<String, dynamic>> collectionReference;
    late Query<Map<String, dynamic>> query;
    late QuerySnapshot<Map<String, dynamic>> querySnapshot;
    late QueryDocumentSnapshot<Map<String, dynamic>> queryDocumentSnapshot;

    setUp(() {
      collectionReference = MockCollectionReference();
      query = MockQuery();
      querySnapshot = MockQuerySnapshot();
      queryDocumentSnapshot = MockQueryDocumentSnapshot();
      when(firestore.collection('users')).thenReturn(collectionReference);
      when(collectionReference.where('nomorhpIbu', isEqualTo: '+6281234567890'))
          .thenReturn(query);

      when(query.limit(1)).thenReturn(query);
    });
    test('isPhoneNumberExist success', () async {
      when(query.get()).thenAnswer(
        (_) => Future.value(querySnapshot),
      );
      when(querySnapshot.docs).thenReturn([queryDocumentSnapshot]);
      final result = await authRepository.isPhoneNumberExist('+6281234567890');

      verify(query.get()).called(1);
      expect(result, true);
    });

    test('isPhoneNumberExist throws an exception if get throws', () async {
      when(query.get()).thenThrow(FirebaseAuthException(code: 'invalid-email'));

      expect(
        () => authRepository.isPhoneNumberExist('+6281234567890'),
        throwsA(isA<FirebaseAuthException>()),
      );
    });

    test('isPhoneNumberExist returns false if querySnapshot.docs is empty',
        () async {
      when(query.get()).thenAnswer(
        (_) => Future.value(querySnapshot),
      );
      when(querySnapshot.docs).thenReturn([]);

      final result = await authRepository.isPhoneNumberExist('+6281234567890');

      expect(result, false);
    });
  });

  group('updateUserAvatar', () {
    late CollectionReference<Map<String, dynamic>> collectionReference;
    late DocumentReference<Map<String, dynamic>> documentReference;
    final user = MockUser(
      isAnonymous: false,
      uid: '12345',
      email: '',
    );
    final FirebaseAuth firebaseAuth = MockFirebaseAuth(
      mockUser: user,
      signedIn: true,
    );
    final uid = firebaseAuth.currentUser?.uid ?? '';

    setUp(() {
      collectionReference = MockCollectionReference();
      documentReference = MockDocumentReference();
    });

    test('updateUserAvatar success', () async {
      when(firestore.collection('users')).thenReturn(collectionReference);
      when(collectionReference.doc(uid)).thenReturn(documentReference);
      final result = authRepository.updateUserAvatar('url');

      expect(result, isA<Future<void>>());
    });

    test('updateUserAvatar throws an exception if firestore throws', () async {
      when(firestore.collection('users')).thenReturn(collectionReference);
      when(collectionReference.doc(uid)).thenReturn(documentReference);
      when(documentReference.update({'photoURL': 'url'}))
          .thenThrow(FirebaseAuthException(code: 'invalid-email'));
      expect(
        () => authRepository.updateUserAvatar('url'),
        throwsA(isA<FirebaseAuthException>()),
      );
    });
  });

  group('uploadImage', () {
    late File file;

    setUp(() {
      file = MockFile();
    });

    test('uploadImage success', () async {
      when(file.path).thenReturn('urlpath');
      final filename = firebaseAuth.currentUser?.uid ?? '';

      final storageRef = firebaseStorage.ref().child(filename);
      final resultPutFile = await storageRef.putFile(file);
      final url = await resultPutFile.ref.getDownloadURL();

      final result = await authRepository.uploadImage(file);

      expect(result, contains(url));
    });
  });

  group('destroyPasscode', () {
    test('destroyPasscode success', () async {
      when(sharedPreferences.remove('passCode'))
          .thenAnswer((_) => Future.value(true));

      final result = await authRepository.destroyPasscode();
      verify(sharedPreferences.remove('passCode')).called(1);
      expect(result, true);
    });

    test('destroyPasscode throws an exception if remove throws', () async {
      when(sharedPreferences.remove('passCode')).thenThrow(
        Exception('error'),
      );

      final result = authRepository.destroyPasscode();

      expect(result, throwsA(isA<Exception>()));
    });
  });
}
