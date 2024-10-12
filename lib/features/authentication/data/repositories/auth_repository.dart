import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../models/user.dart';

@Injectable()
class AuthRepository {
  final SharedPreferences sharedPreferences;
  final SupabaseClient supabaseClient;

  static const String _tableName = 'profiles';

  AuthRepository(
    this.sharedPreferences,
    this.supabaseClient,
  );

  Future<AuthResponse> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> forgetEmailPassword({required String email}) {
    return supabaseClient.auth.resetPasswordForEmail(
      email,
    );
  }

  Future<AuthResponse> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await supabaseClient.auth.signUp(
      email: email,
      password: password,
    );
  }

  Future<void> insertUserToDatabase({
    required Users user,
  }) async {
    try {
      await supabaseClient.auth.updateUser(
        UserAttributes(
          email: user.email,
        ),
      );
      final userResult = user.toSeribaseMap();
      final userId = supabaseClient.auth.currentUser!.id;
      return await supabaseClient
          .from(_tableName)
          .update(
            userResult,
          )
          .eq(
            'user_id',
            userId,
          );
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> signOut() async {
    return await supabaseClient.auth.signOut();
  }

  Future<bool> isSignedIn() async {
    final currentUser = await supabaseClient.auth.currentUser;
    return currentUser != null;
  }

  Future<Users?> getUser() async {
    final user = await supabaseClient.auth.currentUser;
    final userExpand = await supabaseClient.from(_tableName).select().eq(
          'user_id',
          user!.id,
        );
    if (userExpand.isNotEmpty) {
      final userResult = Users.fromSeribase(userExpand.first);
      return userResult.copyWith(
        email: user.email,
        verified: user.emailConfirmedAt != null,
      );
    } else {
      return null;
    }
  }

  Future<String> uploadImage(File file) async {
    try {
      final id = await supabaseClient.auth.currentUser?.id;
      await supabaseClient.storage.from('avatars').upload(
            '$id',
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
            retryAttempts: 3,
          );
      final fullPath = await supabaseClient.storage
          .from('avatars')
          .getPublicUrl('$id');
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
        'user_id',
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
