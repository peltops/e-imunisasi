import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eimunisasi/models/nakes.dart';
import 'package:eimunisasi/services/calendar_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NakesService extends FirestoreDatabase {
  final _service = FirebaseFirestore.instance;

  NakesService() : super(uid: FirebaseAuth.instance.currentUser!.uid);

// Stream List Nakes
  List<Nakes> _listData(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) {
      var data = Map<String, dynamic>.from(e.data() as Map<dynamic, dynamic>);
      data['id'] = e.id;
      return Nakes.fromMap(data);
    }).toList();
  }

  Stream<List<Nakes>> get nakesStream =>
      _service.collection('users_medis').snapshots().map(_listData);
}
