import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eimunisasi/models/rumah_sakit.dart';

class RumahSakitDatabase {
  RumahSakitDatabase({this.uid});
  final String uid;

  final _service = FirebaseFirestore.instance;

  // // add calender event
  // Future<void> setEvent(Calendars calendars) =>
  //     _service.collection('calendars').add(calendars.toMap());

  // // update calender event
  // Future<void> updateEvent(Calendars calendars, docID) =>
  //     _service.collection('calendars').doc(docID).update(calendars.toMap());

  // // delete selected calender
  // Future<void> deleteEvent(docID) =>
  //     _service.collection('calendars').doc(docID).delete();

  // Stream List event Calender
  List<RumahSakitModel> _listData(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) {
      var data = Map<String, dynamic>.from(e.data());
      return RumahSakitModel.fromMap(data);
    }).toList();
  }

  Stream<List<RumahSakitModel>> get streamData =>
      _service.collection('rumah_sakit').snapshots().map(_listData);
}
