import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';

import '../models/anak.dart';

@injectable
class ChildRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;

  static const String _collectionName = 'children';

  ChildRepository(
    this.firestore,
    this.firebaseAuth,
    this.firebaseStorage,
  );

  Future<List<Anak>> getAllChildren() async {
    final _currentUser = firebaseAuth.currentUser;
    if (_currentUser == null) {
      throw Exception('User not logged in');
    }
    final data = await firestore
        .collection(_collectionName)
        .where(
          'parent_id',
          isEqualTo: _currentUser.uid,
        )
        .get();
    final result = data.docs.map((e) {
      final data = Anak.fromMap(e.data());
      return data.copyWith(id: e.id);
    }).toList();
    return result;
  }

  Future<Anak> setChild(Anak anak) async {
    final _currentUser = firebaseAuth.currentUser;
    if (_currentUser == null) {
      throw Exception('User not logged in');
    }
    try {
      final data = anak.copyWith(parentId: _currentUser.uid);
      final result =
          await firestore.collection(_collectionName).add(data.toMap());
      return data.copyWith(id: result.id);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateChild(Anak anak) async {
    final _currentUser = firebaseAuth.currentUser;
    if (_currentUser == null) {
      throw Exception('User not logged in');
    }
    return await firestore
        .collection(_collectionName)
        .doc(anak.id)
        .update(anak.toMap());
  }

  Future<void> deleteChild(String id) async {
    final _currentUser = firebaseAuth.currentUser;
    if (_currentUser == null) {
      throw Exception('User not logged in');
    }
    return await firestore.collection(_collectionName).doc(id).delete();
  }

  Future<String> _uploadImage(File filePath, String id) async {
    final _currentUser = firebaseAuth.currentUser;
    if (_currentUser == null) {
      throw Exception('User not logged in');
    }
    final ref = firebaseStorage.ref().child(id);
    final result = await ref.putFile(filePath);
    final fileUrl = await result.ref.getDownloadURL();
    return fileUrl;
  }

  Future<String> updateChildAvatar({
    required File file,
    required String id,
  }) async {
    final _currentUser = firebaseAuth.currentUser;
    if (_currentUser == null) {
      throw Exception('User not logged in');
    }
    try {
      final url = await _uploadImage(file, id);
      await firestore.collection(_collectionName).doc(id).update(
        {'photo_url': url},
      );
      return url;
    } catch (e) {
      rethrow;
    }
  }
}
