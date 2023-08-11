import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/firebase_services.dart';

@module
abstract class AppModule {
  @preResolve
  Future<FirebaseService> get fireService => FirebaseService.init();
  @injectable
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;
  @injectable
  FirebaseFirestore get firestore => FirebaseFirestore.instance;
  @injectable
  FirebaseStorage get firebaseStorage => FirebaseStorage.instance;
  @preResolve
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();
}
