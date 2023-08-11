import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../models/user.dart';

@Injectable()
class AuthRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;
  final SharedPreferences sharedPreferences;

  AuthRepository(this.firestore, this.firebaseAuth, this.firebaseStorage,
      this.sharedPreferences);

  Future<UserCredential> logInWithEmailAndPassword(
      {required String email, required String password}) {
    return firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> forgetEmailPassword({required String email}) {
    return firebaseAuth.sendPasswordResetEmail(
      email: email,
    );
  }

  Future<void> verifyPhoneNumber({
    required String phone,
    required void Function(String, int?) codeSent,
    required void Function(FirebaseAuthException) verificationFailed,
    required void Function(PhoneAuthCredential) verificationCompleted,
  }) {
    return firebaseAuth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 60),
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: (String verificationId) {},
      verificationCompleted: verificationCompleted,
    );
  }

  Future<UserCredential> signInWithCredential(
      {required String verificationId, required String otp}) async {
    final phoneAuthCredential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );
    return firebaseAuth.signInWithCredential(phoneAuthCredential);
  }

  Future<UserCredential> signUpWithEmailAndPassword(
      {required String email, required String password}) async {
    return await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> insertUserToDatabase({
    required Users user,
  }) async {
    final DocumentReference reference =
        firestore.collection('users').doc(user.uid);
    return await reference.set(user.toJson());
  }

  Future<void> signOut() async {
    return firebaseAuth.signOut();
  }

  Future<bool> isSignedIn() async {
    final currentUser = firebaseAuth.currentUser;
    return currentUser != null;
  }

  Future<Users?> getUser() async {
    final user = await firestore
        .collection('users')
        .doc(firebaseAuth.currentUser?.uid)
        .get();
    if (user.exists) {
      Users userResult = Users.fromMap(user.data() ?? {});
      return userResult;
    } else {
      return null;
    }
  }

  Future<bool> isPhoneNumberExist(String phoneNumber) async {
    final user = await firestore
        .collection('users')
        .where('nomorhpIbu', isEqualTo: phoneNumber)
        .limit(1)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    });
    return user;
  }

  Future<void> updateUserAvatar(String url) async {
    try {
      if (firebaseAuth.currentUser == null) {
        throw Exception('User not found');
      }
      await firebaseAuth.currentUser?.updatePhotoURL(url);
      await firestore
          .collection('users')
          .doc(firebaseAuth.currentUser?.uid)
          .update({'photoURL': url});
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<String> uploadImage(File imageFile) async {
    final fileName = firebaseAuth.currentUser?.uid ?? 'user';

    final ref = firebaseStorage.ref().child(fileName);

    final result = await ref.putFile(imageFile);
    final fileUrl = await result.ref.getDownloadURL();
    return fileUrl;
  }

  Future<bool> destroyPasscode() async {
    return sharedPreferences.remove('passCode');
  }
}
