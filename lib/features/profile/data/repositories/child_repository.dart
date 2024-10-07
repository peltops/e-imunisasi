import 'dart:io';

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
    final data = await supabaseClient.from(_tableName).select();
    final result = data.map((e) => Anak.fromSeribase(e)).toList();
    return result;
  }

  Future<Anak> setChild(Anak anak) async {
    final _currentUser = supabaseClient.auth.currentUser;
    try {
      final data = anak.copyWith(parentId: _currentUser?.id);
      await supabaseClient
          .from(_tableName)
          .upsert(
            data.toSeribaseMap(),
          )
          .select();
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteChild(String id) async {
    return await supabaseClient.from(_tableName).delete().eq('id', id);
  }

  Future<String> _uploadImage(File filePath, String id) async {
    try {
      final bytes = await filePath.readAsBytes();
      final fullPath = await supabaseClient.storage
          .from('avatars')
          .uploadBinary(
            'public/$id',
            bytes,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
            retryAttempts: 3,
          );
      return fullPath;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<FileObject>> _deleteImage(String id) async {
    try {
      return await supabaseClient.storage
          .from('avatars')
          .remove(['public/$id']);
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
