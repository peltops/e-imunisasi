import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eimunisasi/features/authentication/data/models/user.dart';
import 'package:eimunisasi/services/local_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final LocalAuthService _localAuth = LocalAuthService();

  //create user obj on firebaseuser
  Users? _userFromFirebaseUser(User? user) {
    return user != null ? Users(uid: user.uid, email: user.email) : null;
  }

  //auth change user stream
  Stream<Users?> get userActive {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // Sign in with phone number
  Future verifyPhoneNumber(
      String phone, BuildContext context, codeSent, verificationFailed) async {
    _auth
        .verifyPhoneNumber(
            phoneNumber: phone,
            timeout: Duration(seconds: 60),
            verificationCompleted: (AuthCredential credential) async {},
            verificationFailed: verificationFailed,
            codeSent: codeSent,
            codeAutoRetrievalTimeout: (String verificationId) {})
        .catchError((e) => throw e);
  }

  Future checkUserExists(phoneNumber) {
    return _db
        .collection('users')
        .where('nomorhpIbu', isEqualTo: phoneNumber)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    });
  }

  Future signUpWithOTP(smsCode, verId, phoneNumber) async {
    AuthCredential credential =
        PhoneAuthProvider.credential(verificationId: verId, smsCode: smsCode);
    try {
      await _auth.signInWithCredential(credential).then((result) {
        Users _newUser = Users(
            uid: result.user!.uid,
            nomorhpIbu: result.user!.phoneNumber,
            golDarahAyah: '-',
            golDarahIbu: '-');
        //update the user in firestore
        _updateUserFirestore(_newUser, result.user!);
      });
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future signInWithOTP(smsCode, verId, phoneNumber) async {
    AuthCredential credential =
        PhoneAuthProvider.credential(verificationId: verId, smsCode: smsCode);
    try {
      await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  //sign in with email
  Future signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  //register with email
  Future signUp(String email, String password,
      {String? momName, String? nomorhpIbu}) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((result) {
        Users _newUser = Users(
            uid: result.user!.uid,
            email: result.user!.email,
            golDarahAyah: '-',
            golDarahIbu: '-',
            verified: result.user!.emailVerified);
        // send verification to user email
        result.user!.sendEmailVerification();
        //update the user in firestore
        _updateUserFirestore(_newUser, result.user!);
      });
    } catch (e) {
      throw e;
    }
  }

  void _updateUserFirestore(Users user, User firebaseUser) {
    _db
        .collection('users')
        .doc(firebaseUser.uid)
        .set(user.toJson())
        .then((value) => print('User added!'))
        .catchError((onError) => print(onError));
  }

  //Reset Password
  Future recoveryPassword(String email) async {
    return await _auth.sendPasswordResetEmail(email: email);
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut().then(
            (_) async => await _localAuth.deletePasscode(),
          );
    } catch (e) {
      return null;
    }
  }
}
