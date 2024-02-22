import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eimunisasi/features/profile/data/models/anak.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AnakService {
  final _currentUser = FirebaseAuth.instance.currentUser;
  final _service = FirebaseFirestore.instance;

  AnakService();

  // add appointment event
  Future<Anak> setData(Anak anak) {
    final data = anak.copyWith(parentId: _currentUser!.uid);
    return _service.collection('children').add(data.toMap()).then((value) {
      return Future.value(data.copyWith(id: value.id));
    });
  }

  // add new and update avatar
  Future<void> updatePhoto(String url, String? id) =>
      _service.collection('children').doc(id).update({'photo_url': url});

  // update appointment event
  Future<void> updateData(Anak anak) =>
      _service.collection('children').doc(anak.id).update(anak.toMap());

// Stream List Nakes
  List<Anak> _listData(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) {
      var data = Map<String, dynamic>.from(e.data() as Map<dynamic, dynamic>);
      data['id'] = e.id;
      return Anak.fromMap(data);
    }).toList();
  }

  Stream<List<Anak>> get anakStream => _service
      .collection('children')
      .where('parent_id', isEqualTo: _currentUser!.uid)
      .snapshots()
      .map(_listData);

  //Upload Image firebase Storage
  Future<String> uploadImage(File imageFile) async {
    String fileName = _currentUser!.uid.toString();

    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref().child(fileName);

    final result = await ref.putFile(imageFile);
    final fileUrl = await result.ref.getDownloadURL();
    return fileUrl;
  }
}
