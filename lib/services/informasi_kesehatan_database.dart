import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eimunisasi/models/informasi_kesehatan.dart';

class InformasiKesehatanDatabase {
  InformasiKesehatanDatabase({this.uid});
  final String? uid;

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
  List<InformasiKesehatanModel> _listData(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) {
      var data = Map<String, dynamic>.from(e.data() as Map<dynamic, dynamic>);
      return InformasiKesehatanModel.fromMap(data);
    }).toList();
  }

  Stream<List<InformasiKesehatanModel>> get streamData =>
      _service.collection('informasi_kesehatan').snapshots().map(_listData);
}
