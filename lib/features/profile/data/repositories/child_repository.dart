import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eimunisasi/features/profile/data/models/anak.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@injectable
class ChildRepository {
  final SupabaseClient supabaseClient;

  static const String _tableName = 'children';

  ChildRepository(
    this.supabaseClient,
  );

  Future<List<Anak>> getAllChildren() async {
    final data = await supabaseClient.from(_tableName).select().order(
          'created_at',
          ascending: true,
        );
    final result = data.map((e) => Anak.fromSeribase(e)).toList();
    return result;
  }

  Future<Anak> setChild(Anak anak) async {
    final _currentUser = supabaseClient.auth.currentUser;
    try {
      final data = anak.copyWith(parentId: _currentUser?.id);
      final result = await supabaseClient
          .from(_tableName)
          .insert(
            data.toSeribaseMap(),
          )
          .select('id')
          .limit(1)
          .single();
      return data.copyWith(id: result['id'] ?? '');
    } catch (e) {
      rethrow;
    }
  }

  Future<Anak> updateChild(Anak anak) async {
    final _currentUser = supabaseClient.auth.currentUser;
    try {
      final data = anak.copyWith(parentId: _currentUser?.id);
      if (anak.id == null) throw 'ID anak tidak ditemukan';
      await supabaseClient
          .from(_tableName)
          .update(
            data.toSeribaseMap(),
          )
          .eq('id', anak.id!)
          .select();

      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteChild(String id) async {
    return await supabaseClient.from(_tableName).delete().eq('id', id);
  }

  Future<String> _uploadImage(File file, String id) async {
    try {
      await supabaseClient.storage.from('avatars').upload(
            '$id',
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
            retryAttempts: 3,
          );
      final fullPath =
          await supabaseClient.storage.from('avatars').getPublicUrl('$id');
      await CachedNetworkImage.evictFromCache(fullPath);
      return fullPath;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<FileObject>> _deleteImage(String id) async {
    try {
      return await supabaseClient.storage.from('avatars').remove(['$id']);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> updateChildAvatar({
    required File file,
    required String id,
  }) async {
    try {
      final url = await _uploadImage(file, id);
      await supabaseClient
          .from(_tableName)
          .update(
            {'avatar_url': url},
          )
          .eq('id', id)
          .catchError((e) {
            _deleteImage(id);
            throw e;
          });
      return url;
    } catch (e) {
      rethrow;
    }
  }
}
