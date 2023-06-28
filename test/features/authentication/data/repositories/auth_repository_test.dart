import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eimunisasi/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';
import 'package:eimunisasi/features/authentication/data/repositories/auth_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';

@GenerateMocks([
  FirebaseAuth,
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
  MockSpec<User>(),
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

  setUp(() {
    firebaseAuth = MockFirebaseAuth();
    firestore = MockFirebaseFirestore();
    firebaseStorage = MockFirebaseStorage();
    sharedPreferences = MockSharedPreferences();
    authRepository = AuthRepository(
        firestore, firebaseAuth, firebaseStorage, sharedPreferences);
  });

  group('logInWithEmailAndPassword', () {
    late String email;
    late String password;
    late UserCredential userCredential;

    setUp(() {
      email = 'example@ex.com';
      password = '123456';
      userCredential = MockUserCredential();
    });
    test(
        'logInWithEmailAndPassword calls signInWithEmailAndPassword with correct arguments',
        () async {
      when(
        firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        ),
      ).thenAnswer((_) => Future<UserCredential>.value(userCredential));
      await authRepository.logInWithEmailAndPassword(
        email: email,
        password: password,
      );
      verify(
        firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        ),
      ).called(1);
    });
    test(
        'logInWithEmailAndPassword throws an exception if signInWithEmailAndPassword throws',
        () async {
      when(firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      )).thenThrow(FirebaseAuthException(code: 'invalid-email'));

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
      await authRepository.forgetEmailPassword(email: email);
      verify(
        firebaseAuth.sendPasswordResetEmail(
          email: email,
        ),
      ).called(1);
    });
    test(
        'forgetEmailPassword throws an exception if sendPasswordResetEmail throws',
        () async {
      when(firebaseAuth.sendPasswordResetEmail(
        email: email,
      )).thenThrow(FirebaseAuthException(code: 'invalid-email'));

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
      when(firebaseAuth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: const Duration(seconds: 60),
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: (String verificationId) {},
        verificationCompleted: verificationCompleted,
      )).thenAnswer((_) => Future.value());

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
    late PhoneAuthCredential credential;
    late UserCredential userCredential;

    setUp(() {
      credential = PhoneAuthProvider.credential(
          verificationId: '123456', smsCode: '123456');
      userCredential = MockUserCredential();
    });
    test(
        'signInWithCredential calls signInWithCredential with correct arguments',
        () async {
      when(
        firebaseAuth.signInWithCredential(credential),
      ).thenAnswer((_) => Future<UserCredential>.value(userCredential));
      await authRepository.signInWithCredential(credential);
      verify(
        firebaseAuth.signInWithCredential(credential),
      ).called(1);
    });
    test(
        'signInWithCredential throws an exception if signInWithCredential throws',
        () async {
      when(firebaseAuth.signInWithCredential(credential))
          .thenThrow(FirebaseAuthException(code: 'invalid-credential'));

      expect(
        () => authRepository.signInWithCredential(credential),
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
      when(firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      )).thenAnswer((_) => Future.value(userCredential));
      final result = await authRepository.signUpWithEmailAndPassword(
        email: email,
        password: password,
      );
      verify(
        firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        ),
      ).called(1);
      expect(result, userCredential);
    });
    test(
      'signUpWithEmailAndPassword throws an exception if createUserWithEmailAndPassword throws',
      () async {
        when(firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        )).thenThrow(FirebaseAuthException(code: 'invalid-email'));

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
      when(firebaseAuth.signOut()).thenAnswer((_) => Future.value());
      final result = authRepository.signOut();
      verify(firebaseAuth.signOut()).called(1);
      expect(result, isA<Future<void>>());
    });

    test('signOut throws an exception if signOut throws', () {
      when(firebaseAuth.signOut())
          .thenThrow(FirebaseAuthException(code: 'invalid-email'));

      expect(
        () => authRepository.signOut(),
        throwsA(isA<FirebaseAuthException>()),
      );
    });
  });

  group('isSignedIn', () {
    late User user;
    setUp(() {
      user = MockUser();
    });

    test('isSignedIn success', () async {
      when(firebaseAuth.currentUser).thenReturn(user);
      final result = await authRepository.isSignedIn();
      verify(firebaseAuth.currentUser).called(1);
      expect(result, true);
    });

    test('isSignedIn returns false if currentUser is null', () async {
      when(firebaseAuth.currentUser).thenReturn(null);
      final result = await authRepository.isSignedIn();
      verify(firebaseAuth.currentUser).called(1);
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
      user = MockUser();
      users = MockUsers();
      collectionReference = MockCollectionReference();
      documentReference = MockDocumentReference();
      documentSnapshot = MockDocumentSnapshot();
      when(firebaseAuth.currentUser).thenReturn(user);
      when(firestore.collection('users')).thenReturn(collectionReference);
      when(collectionReference.doc(user.uid)).thenReturn(documentReference);
    });

    test('getUser success', () async {
      when(documentReference.get()).thenAnswer(
        (_) => Future.value(documentSnapshot),
      );
      when(documentSnapshot.exists).thenReturn(true);
      when(documentSnapshot.data()).thenReturn(users.toJson());

      final result = await authRepository.getUser();
      verify(firebaseAuth.currentUser).called(1);
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
    late User firebaseUser;
    late CollectionReference<Map<String, dynamic>> collectionReference;
    late DocumentReference<Map<String, dynamic>> documentReference;

    setUp(() {
      firebaseUser = MockUser();
      collectionReference = MockCollectionReference();
      documentReference = MockDocumentReference();
    });

    test('updateUserAvatar success', () async {
      when(firebaseAuth.currentUser).thenReturn(firebaseUser);
      when(firestore.collection('users')).thenReturn(collectionReference);
      when(collectionReference.doc(firebaseUser.uid))
          .thenReturn(documentReference);
      when(firebaseUser.updatePhotoURL('url'))
          .thenAnswer((_) => Future.value());
      final result = authRepository.updateUserAvatar('url');

      verify(firebaseAuth.currentUser).called(1);
      verify(firebaseUser.updatePhotoURL('url')).called(1);

      expect(result, isA<Future<void>>());
    });

    test('updateUserAvatar throws an exception if updatePhotoURL throws',
        () async {
      when(firebaseAuth.currentUser).thenReturn(firebaseUser);
      when(firestore.collection('users')).thenReturn(collectionReference);
      when(collectionReference.doc(firebaseUser.uid))
          .thenReturn(documentReference);
      when(firebaseUser.updatePhotoURL('url'))
          .thenThrow(FirebaseAuthException(code: 'invalid-email'));

      expect(
        () => authRepository.updateUserAvatar('url'),
        throwsA(isA<FirebaseAuthException>()),
      );
    });

    test('updateUserAvatar throws an exception if firestore throws', () async {
      when(firebaseAuth.currentUser).thenReturn(firebaseUser);
      when(firestore.collection('users')).thenReturn(collectionReference);
      when(collectionReference.doc(firebaseUser.uid))
          .thenReturn(documentReference);
      when(firebaseUser.updatePhotoURL('url'))
          .thenAnswer((_) => Future.value());
      when(documentReference.update({'photoURL': 'url'}))
          .thenThrow(FirebaseAuthException(code: 'invalid-email'));
      expect(
        () => authRepository.updateUserAvatar('url'),
        throwsA(isA<FirebaseAuthException>()),
      );
    });
  });

  group('uploadImage', () {
    late User firebaseUser;
    late FirebaseStorage mockitoStorage;
    late Reference reference;
    late Reference referenceChild;
    late Reference referencePutFile;
    late TaskSnapshot taskSnapshot;
    late UploadTask uploadTask;
    late File file;
    late String uid;

    setUp(() {
      firebaseUser = MockUser();
      mockitoStorage = MockFirebaseStorage();
      reference = MockReference();
      file = MockFile();
      uid = "firebaseUser321#";
    });

    test('uploadImage success', () async {
      when(firebaseUser.uid).thenReturn(uid);
      when(file.path).thenReturn('urlpath');
      when(firebaseAuth.currentUser).thenReturn(firebaseUser);
      final filename = firebaseUser.uid;

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
