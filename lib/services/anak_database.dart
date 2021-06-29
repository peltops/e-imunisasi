import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eimunisasi/models/anak.dart';
import 'package:eimunisasi/services/calendar_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AnakService extends FirestoreDatabase {
  final _currentUser = FirebaseAuth.instance.currentUser;
  final _service = FirebaseFirestore.instance;
  Future<void> setData(Anak anak, int index, {bool set = false}) => (set)
      ? _service
          .collection('anak')
          .doc(_currentUser.uid)
          .set(anak.toMap(index + 1))
      : _service
          .collection('anak')
          .doc(_currentUser.uid)
          .update(anak.toMap(index + 1));

  Stream<DocumentSnapshot<Map<String, dynamic>>> get documentStream =>
      FirebaseFirestore.instance
          .collection('anak')
          .doc(_currentUser.uid)
          .snapshots();
}
