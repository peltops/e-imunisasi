import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eimunisasi/models/jadwal_janji.dart';
import 'package:flutter/material.dart';

class AppointmentService {
  AppointmentService({@required this.uid});
  final String uid;

  final _service = FirebaseFirestore.instance;

  // add appointment event
  Future<JadwalJanjiModel> setAppointment(JadwalJanjiModel appointment) {
    return _service
        .collection('appointments')
        .add(appointment.toMap())
        .then((value) {
      print(value.id);
      return Future.value(appointment.copyWith(id: value.id));
    });
  }

  // update appointment event
  Future<void> updateAppointment(JadwalJanjiModel appointment, docID) =>
      _service
          .collection('appointments')
          .doc(docID)
          .update(appointment.toMap());

  // delete selected appointment
  Future<void> deleteAppointment(docID) =>
      _service.collection('appointments').doc(docID).delete();

  // Stream List appointment
  List<JadwalJanjiModel> _listAppointment(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) {
      var data = Map<String, dynamic>.from(e.data());
      return JadwalJanjiModel.fromMap(data, e.id);
    }).toList();
  }

  Stream<List<JadwalJanjiModel>> get appointmentsStream => _service
      .collection('appointments')
      .where('uid', isEqualTo: uid)
      .orderBy('date')
      .snapshots()
      .map(_listAppointment);
}
