import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../models/user.dart';

@Injectable()
class AuthRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;
  final SharedPreferences sharedPreferences;
  final SupabaseClient supabaseClient;

  static const String _tableName = 'profiles';

  AuthRepository(
    this.firestore,
    this.firebaseAuth,
    this.firebaseStorage,
    this.sharedPreferences,
    this.supabaseClient,
  );

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
    return await supabaseClient.auth.signOut();
  }

  Future<bool> isSignedIn() async {
    final currentUser = firebaseAuth.currentUser;
    return currentUser != null;
  }

  Future<Users?> getUser() async {
    final user = await supabaseClient.auth.currentUser;
    final userExpand = await supabaseClient.from(_tableName).select();
    if (user != null && userExpand.isNotEmpty) {
      final userResult = Users.fromSeribase(userExpand.first);
      return userResult.copyWith(
        email: user.email,
        verified: user.emailConfirmedAt != null,
      );
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

  Future<String> uploadImage(File file) async {
    try {
      final id = await supabaseClient.auth.currentUser?.id;
      final fullPath = await supabaseClient.storage.from('avatars').upload(
            'public/$id',
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
            retryAttempts: 3,
          );
      return fullPath;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUserAvatar(String url) async {
    try {
      if (supabaseClient.auth.currentUser == null) {
        throw Exception('User not found');
      }
      await supabaseClient.from(_tableName).update({'avatar_url': url}).eq(
        'id',
        supabaseClient.auth.currentUser!.id,
      );
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> verifyEmail() async {
    try {
      await supabaseClient.auth.resend(
        type: OtpType.signup,
        email: supabaseClient.auth.currentUser?.email,
      );
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<bool> destroyPasscode() async {
    return sharedPreferences.remove('passCode');
  }

  Future<bool> logInWithSeribaseOauth() async {
    return await supabaseClient.auth.signInWithOAuth(
      supabase.OAuthProvider.keycloak,
      scopes: 'openid',
    );
  }
}
