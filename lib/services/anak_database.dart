import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eimunisasi/models/anak.dart';
import 'package:eimunisasi/services/calendar_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AnakService extends FirestoreDatabase {
  final _currentUser = FirebaseAuth.instance.currentUser;
  final _service = FirebaseFirestore.instance;

  // add new and update anak
  Future<void> setData(Anak anak, int index, {bool set = false}) => (set)
      ? _service
          .collection('children')
          .doc(_currentUser.uid)
          .set(anak.toMap(index + 1))
      : _service
          .collection('children')
          .doc(_currentUser.uid)
          .update(anak.toMap(index + 1));

// Stream List Anak
  List<Anak> _listAnak(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    // print(snapshot.data().values.map((e) => e.runtimeType));
    return snapshot.data().values.map((e) => Anak.fromMap(e)).toList();
  }

  Stream<List<Anak>> get anakStream => _service
      .collection('children')
      .doc(_currentUser.uid)
      .snapshots()
      .map(_listAnak);

  // stream anak
  Stream<DocumentSnapshot<Map<String, dynamic>>> get documentStream =>
      FirebaseFirestore.instance
          .collection('children')
          .doc(_currentUser.uid)
          .snapshots();
}
