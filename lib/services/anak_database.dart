import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eimunisasi/models/anak.dart';
import 'package:eimunisasi/services/calendar_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AnakService extends FirestoreDatabase {
  final _currentUser = FirebaseAuth.instance.currentUser;
  final _service = FirebaseFirestore.instance;

  // add appointment event
  Future<Anak> setData(Anak anak) {
    final data = anak.copyWith(parentId: _currentUser.uid);
    return _service.collection('children').add(data.toMap()).then((value) {
      print(value.id);
      return Future.value(data.copyWith(id: value.id));
    });
  }

  // update appointment event
  Future<void> updateData(Anak anak) =>
      _service.collection('children').doc(anak.id).update(anak.toMap());

// Stream List Nakes
  List<Anak> _listData(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) {
      var data = Map<String, dynamic>.from(e.data());
      data['id'] = e.id;
      log(data.toString());
      return Anak.fromMap(data);
    }).toList();
  }

  Stream<List<Anak>> get anakStream => _service
      .collection('children')
      .where('parentId', isEqualTo: _currentUser.uid)
      .snapshots()
      .map(_listData);
}
