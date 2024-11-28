import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@module
abstract class AppModule {
  @preResolve
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();
  @injectable
  HiveInterface get hiveInterface => Hive;
  @injectable
  SupabaseClient get supabaseClient => Supabase.instance.client;
}
