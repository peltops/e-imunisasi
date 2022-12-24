import 'package:cloud_firestore/cloud_firestore.dart';

class NakesModel {
  final String nama;
  final String telepon;
  final String spesialis;

  NakesModel({
    this.nama,
    this.telepon,
    this.spesialis,
  });

  factory NakesModel.fromMap(Map data) {
    return NakesModel(
      nama: data['nama'],
      telepon: data['telepon'],
      spesialis: data['spesialis'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      "nama": nama,
      "telepon": telepon,
      "spesialis": spesialis,
    };
  }
}

class Nakes {
  // Document ID	clinicID	email	jadwal	kartuKeluarga	namaLengkap	nik	noTelpon	photoURL profesi	tanggalLahir	tempatLahir
  final String id;
  final String clinicID;
  final String email;
  final List<JadwalPraktek> jadwal;
  final List<JadwalPraktek> jadwalImunisasi;
  final String kartuKeluarga;
  final String namaLengkap;
  final String nik;
  final String noTelpon;
  final String photoURL;
  final String profesi;
  final DateTime tanggalLahir;
  final String tempatLahir;

  Nakes({
    this.id,
    this.clinicID,
    this.email,
    this.jadwal,
    this.jadwalImunisasi,
    this.kartuKeluarga,
    this.namaLengkap,
    this.nik,
    this.noTelpon,
    this.photoURL,
    this.profesi,
    this.tanggalLahir,
    this.tempatLahir,
  });

  factory Nakes.fromMap(Map data) {
    return Nakes(
      id: data['id'],
      clinicID: data['clinicID'],
      email: data['email'],
      jadwal: (data['jadwal'] as List ?? [])
          .map((e) => JadwalPraktek.fromMap(e))
          .toList(),
      jadwalImunisasi: (data['jadwalImunisasi'] as List ?? [])
          .map((e) => JadwalPraktek.fromMap(e))
          .toList(),
      kartuKeluarga: data['kartuKeluarga'],
      namaLengkap: data['namaLengkap'],
      nik: data['nik'],
      noTelpon: data['noTelpon'],
      photoURL: data['photoURL'],
      profesi: data['profesi'],
      tanggalLahir: () {
        if (data['tanggalLahir'] is Timestamp) {
          return (data['tanggalLahir'] as Timestamp).toDate();
        } else {
          return null;
        }
      }(),
      tempatLahir: data['tempatLahir'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "clinicID": clinicID,
      "email": email,
      "jadwal": jadwal,
      "kartuKeluarga": kartuKeluarga,
      "namaLengkap": namaLengkap,
      "nik": nik,
      "noTelpon": noTelpon,
      "photoURL": photoURL,
      "profesi": profesi,
      "tanggalLahir": tanggalLahir,
      "tempatLahir": tempatLahir,
    };
  }
}

class JadwalPraktek {
  final String hari;
  final String jam;

  JadwalPraktek({
    this.hari,
    this.jam,
  });

  factory JadwalPraktek.fromMap(Map data) {
    return JadwalPraktek(
      hari: data['hari'],
      jam: data['jam'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "hari": hari,
      "jam": jam,
    };
  }
}
