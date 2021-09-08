import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eimunisasi/models/calendar.dart';
import 'package:flutter/material.dart';

class FirestoreDatabase {
  FirestoreDatabase({@required this.uid});
  final String uid;

  final _service = FirebaseFirestore.instance;

  // add calender event
  Future<void> setEvent(KalenderModel calendars) =>
      _service.collection('calendars').add(calendars.toMap());

  // update calender event
  Future<void> updateEvent(KalenderModel calendars, docID) =>
      _service.collection('calendars').doc(docID).update(calendars.toMap());

  // delete selected calender
  Future<void> deleteEvent(docID) =>
      _service.collection('calendars').doc(docID).delete();

  // Stream List event Calender
  List<KalenderModel> _listEventKalender(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) {
      var data = Map<String, dynamic>.from(e.data());
      return KalenderModel.fromMap(data, e);
    }).toList();
  }

  Stream<List<KalenderModel>> get calendarsStream => _service
      .collection('calendars')
      .where('uid', isEqualTo: uid)
      .orderBy('date')
      .snapshots()
      .map(_listEventKalender);
}
