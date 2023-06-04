import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../models/user.dart';

@Injectable()
class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  AuthRepository(FirebaseAuth firebaseAuth, FirebaseFirestore firestore)
      : _firebaseAuth = firebaseAuth,
        _firestore = firestore;

  Future<void> logInWithEmailAndPassword(
      {required String email, required String password}) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> forgetEmailPassword({required String email}) {
    return _firebaseAuth.sendPasswordResetEmail(
      email: email,
    );
  }

  Future<void> verifyPhoneNumber({
    required String phone,
    required void Function(String, int?) codeSent,
    required void Function(FirebaseAuthException) verificationFailed,
    required void Function(PhoneAuthCredential) verificationCompleted,
  }) {
    return _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 60),
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: (String verificationId) {},
      verificationCompleted: verificationCompleted,
    );
  }

  // signin with credential
  Future<UserCredential> signInWithCredential(PhoneAuthCredential credential) {
    return _firebaseAuth.signInWithCredential(credential);
  }

  Future<UserCredential> signUpWithOTP(smsCode, verId) async {
    AuthCredential credential =
        PhoneAuthProvider.credential(verificationId: verId, smsCode: smsCode);
    try {
      return await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential> signUpWithEmailAndPassword(
      {required String email, required String password}) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> insertUserToDatabase({
    required Users user,
  }) async {
    final DocumentReference reference =
        _firestore.collection('users').doc(user.uid);
    return await reference.set(user.toJson());
  }

  Future<bool> isUserExist() async {
    final isSignedIn = await this.isSignedIn();
    final getUser = await this.getUser();
    final isUserExist = getUser != null;
    if (isSignedIn && isUserExist) {
      return true;
    }
    return false;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<bool> isSignedIn() async {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser != null;
  }

  Future<Users?> getUser() async {
    final user = await _firestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .get();
    if (user.exists) {
      Users userResult = Users.fromMap(user.data() ?? {});
      return userResult;
    } else {
      return null;
    }
  }

  // add new and update avatar
  Future<void> updateUserAvatar(String url) async {
    try {
      await _firebaseAuth.currentUser?.updatePhotoURL(url);
      await _firestore
          .collection('users_medis')
          .doc(_firebaseAuth.currentUser?.uid)
          .update({'photoURL': url});
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  //Upload Image firebase Storage
  Future<String> uploadImage(File imageFile) async {
    final fileName = _firebaseAuth.currentUser?.uid ?? 'user';

    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref().child(fileName);

    final result = await ref.putFile(imageFile);
    final fileUrl = await result.ref.getDownloadURL();
    return fileUrl;
  }

  Future destroyPasscode() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.remove('passCode');
  }
}
