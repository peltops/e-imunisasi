import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eimunisasi/models/anak.dart';
import 'package:eimunisasi/models/appointment.dart';
import 'package:eimunisasi/models/nakes.dart';
import 'package:eimunisasi/models/user.dart';
import 'package:flutter/material.dart';

class AppointmentService {
  AppointmentService({@required this.uid});
  final String uid;

  final _service = FirebaseFirestore.instance;

  // add appointment event
  Future<AppointmentModel> setAppointment(AppointmentModel appointment) {
    return _service
        .collection('appointments')
        .add(appointment.toMap())
        .then((value) {
      return Future.value(appointment.copyWith(id: value.id));
    });
  }

  // update appointment event
  Future<void> updateAppointment(AppointmentModel appointment, docID) =>
      _service
          .collection('appointments')
          .doc(docID)
          .update(appointment.toMap());

  // delete selected appointment
  Future<void> deleteAppointment(docID) =>
      _service.collection('appointments').doc(docID).delete();

  Future<List<AppointmentModel>> getAppointment() async {
    List<AppointmentModel> result = [];
    final jadwalPasien = await _service
        .collection('appointments')
        .where('parent_id', isEqualTo: uid)
        .get();
    for (var element in jadwalPasien.docs) {
      AppointmentModel dataJadwal = AppointmentModel.fromMap(
        element.data(),
        element.id,
      );

      final anak = await _service
          .collection('children')
          .doc(element.data()['patient_id'])
          .get();
      anak.data()['id'] = anak.id;
      final orangtua = await _service.collection('users').doc(uid).get();
      orangtua.data()['uid'] = orangtua.id;
      final nakes = await _service
          .collection('users_medis')
          .doc(element.data()['medic_id'])
          .get();
      nakes.data()['id'] = nakes.id;

      dataJadwal = dataJadwal.copyWith(
        anak: Anak.fromMap(anak.data()),
        orangtua: Users.fromMap(orangtua.data()),
        nakes: Nakes.fromMap(nakes.data()),
      );
      result.add(dataJadwal);
    }
    return result;
  }

  // Stream List appointment
  List<AppointmentModel> _listAppointment(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) {
      var data = Map<String, dynamic>.from(e.data());
      return AppointmentModel.fromMap(data, e.id);
    }).toList();
  }

  Stream<List<AppointmentModel>> get appointmentsStream => _service
      .collection('appointments')
      .where('parent_id', isEqualTo: uid)
      .orderBy('appointment_date')
      .snapshots()
      .map(_listAppointment);
}
