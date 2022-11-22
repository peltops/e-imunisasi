import 'package:eimunisasi/models/anak.dart';
import 'package:eimunisasi/models/nakes.dart';
import 'package:eimunisasi/models/user.dart';
import 'package:equatable/equatable.dart';

class AppointmentModel extends Equatable {
  final String id;
  final DateTime tanggal;
  final Anak anak;
  final Users orangtua;
  final Nakes nakes;
  final String tujuan;
  final String desc;
  final String notes;

  const AppointmentModel({
    this.id,
    this.tanggal,
    this.anak,
    this.orangtua,
    this.nakes,
    this.notes,
    this.desc,
    this.tujuan,
  });

  AppointmentModel copyWith({
    String id,
    DateTime tanggal,
    Anak anak,
    Users orangtua,
    Nakes nakes,
    String notes,
    String desc,
    String tujuan,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      tanggal: tanggal ?? this.tanggal,
      anak: anak ?? this.anak,
      orangtua: orangtua ?? this.orangtua,
      nakes: nakes ?? this.nakes,
      notes: notes ?? this.notes,
      desc: desc ?? this.desc,
      tujuan: tujuan ?? this.tujuan,
    );
  }

  @override
  List<Object> get props => [
        id,
        tanggal,
        anak,
        orangtua,
        nakes,
        notes,
        desc,
        tujuan,
      ];

  factory AppointmentModel.fromMap(Map<String, dynamic> map, String docId) {
    return AppointmentModel(
      id: docId,
      tanggal: map['appointment_date'].toDate(),
      notes: map['notes'],
      desc: map['appointment_desc'],
      tujuan: map['purpose'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'appointment_date': tanggal,
      'appointment_desc': desc,
      'medic_id': nakes.id,
      'notes': notes,
      'parent_id': orangtua.uid,
      'patient_id': anak.id,
      'purpose': tujuan,
    };
  }
}
