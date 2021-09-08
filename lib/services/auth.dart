import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eimunisasi/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //create user obj on firebaseuser
  Users _userFromFirebaseUser(User user) {
    return user != null ? Users(uid: user.uid, email: user.email) : null;
  }

  //auth change user stream
  Stream<Users> get userActive {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  //sign in with email
  Future signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  //register with email
  Future signUp(String email, String password,
      {String momName, String nomorhpIbu}) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((result) {
        Users _newUser = Users(
            uid: result.user.uid,
            email: result.user.email,
            momName: momName,
            nomorhpIbu: nomorhpIbu,
            golDarahAyah: '-',
            golDarahIbu: '-',
            verified: result.user.emailVerified);
        //update the user in firestore
        _updateUserFirestore(_newUser, result.user);
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
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }
}
