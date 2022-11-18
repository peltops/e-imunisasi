import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eimunisasi/models/nakes.dart';

class NakesDatabase {
  NakesDatabase({this.uid});
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
  List<NakesModel> _listData(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) {
      var data = Map<String, dynamic>.from(e.data());
      return NakesModel.fromMap(data);
    }).toList();
  }

  Stream<List<NakesModel>> get nakesStream =>
      _service.collection('tenaga_kesehatan').snapshots().map(_listData);
}
