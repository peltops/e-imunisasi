import 'package:e_imunisasi/models/user.dart';
import 'package:e_imunisasi/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //creat user obj on firebaseuser
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid, email: user.email) : null;
  }

  //auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  //sign in with email
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      print(user.isEmailVerified);
      return user.isEmailVerified
          ? _userFromFirebaseUser(user)
          : print('Email belum diverifikasi');
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register with email
  Future registerWithEmailAndPassword(
      String name, String email, String password, String typeRegis) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      typeRegis == 'anakCollection'
          ? await DatabaseService(uid: user.uid, email: user.email)
              .updateUserDataAnak(email, name, '', '', '', '', '', '', '', '')
          : await DatabaseService(uid: user.uid, email: user.email)
              .updateUserDataMedis(email, name, '', '', '', '', '');
      await user.sendEmailVerification();
      return _userFromFirebaseUser(user);
    } catch (e) {
      print("An error occured while trying to send email verification");
      print(e.message);
      return null;
    }
  }

  //Reset Password
  Future recoveryPassword(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  Future cekVerifiedEmail() async {
    try {
      FirebaseUser user = await _auth.currentUser();
      await user.reload();
      user = await _auth.currentUser();
      return user;
    } catch (e) {
      return e.message;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
