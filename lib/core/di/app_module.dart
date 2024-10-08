import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../services/firebase_services.dart';

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
  @injectable
  HiveInterface get hiveInterface => Hive;
  @injectable
  SupabaseClient get supabaseClient => Supabase.instance.client;
}
