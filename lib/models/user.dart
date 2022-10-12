import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String uid;
  final String momName;
  final String dadName;
  final String nomorhpAyah;
  final String nomorhpIbu;
  final String email;
  final String golDarahAyah;
  final String golDarahIbu;
  final String pekerjaanAyah;
  final String pekerjaanIbu;
  final String alamat;
  final String avatarURL;
  final bool verified;
  final String tempatLahir;
  final DateTime tanggalLahir;
  final String noKK;
  final String noKTP;
  Users({
    this.golDarahAyah,
    this.golDarahIbu,
    this.pekerjaanAyah,
    this.pekerjaanIbu,
    this.nomorhpAyah,
    this.nomorhpIbu,
    this.alamat,
    this.momName,
    this.dadName,
    this.uid,
    this.email,
    this.avatarURL,
    this.verified,
    this.tempatLahir,
    this.tanggalLahir,
    this.noKK,
    this.noKTP,
  });

  factory Users.fromMap(Map data) {
    return Users(
      uid: data['uid'],
      email: data['email'] ?? '',
      momName: data['momName'] ?? '',
      dadName: data['dadName'] ?? '',
      nomorhpAyah: data['nomorhpAyah'] ?? '',
      nomorhpIbu: data['nomorhpIbu'] ?? '',
      golDarahAyah: data['golDarahAyah'] ?? '',
      golDarahIbu: data['golDarahIbu'] ?? '',
      pekerjaanAyah: data['pekerjaanAyah'] ?? '',
      pekerjaanIbu: data['pekerjaanIbu'] ?? '',
      alamat: data['alamat'] ?? '',
      avatarURL: data['avatarURL'] ?? '',
      verified: data['verified'] ?? false,
      tempatLahir: data['tempatLahir'] ?? '',
      tanggalLahir:
          (data['tanggalLahir'] as Timestamp).toDate() ?? DateTime.now(),
      noKK: data['noKK'] ?? '',
      noKTP: data['noKTP'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
        "momName": momName,
        "dadName": dadName,
        "nomorhpAyah": nomorhpAyah,
        "nomorhpIbu": nomorhpIbu,
        'golDarahAyah': golDarahAyah,
        'golDarahIbu': golDarahIbu,
        'pekerjaanAyah': pekerjaanAyah,
        'pekerjaanIbu': pekerjaanIbu,
        'alamat': alamat,
        'avatarURL': avatarURL,
        "verified": verified,
        "tempatLahir": tempatLahir,
        "tanggalLahir": tanggalLahir,
        "noKK": noKK,
        "noKTP": noKTP,
      };
}

class UserData {
  final String uid;
  final String email;
  final String avatarURL;
  final String nama;
  final String nik;
  final String tgllahir;
  final String namaAyah;
  final String pekerjaanAyah;
  final String namaIbu;
  final String pekerjaanIbu;
  final String alamat;
  final String unitKerja;
  final String noTlp;

  UserData(
      {this.uid,
      this.email,
      this.avatarURL,
      this.nama,
      this.nik,
      this.tgllahir,
      this.namaAyah,
      this.pekerjaanAyah,
      this.namaIbu,
      this.pekerjaanIbu,
      this.alamat,
      this.unitKerja,
      this.noTlp});
}

class GetAllUser {
  final String nama;
  final String tgllahir;
  final String email;
  final String documentID;

  GetAllUser({this.nama, this.tgllahir, this.email, this.documentID});
  Map<String, dynamic> toMap() {
    return {
      "email": email,
      "nama": nama,
      "tgllahir": tgllahir,
    };
  }
}

class DataTumbuh {
  final String idMedis;
  final String idPeserta;
  final String nama;
  final String email;
  final String tgllahir;
  final String beratBadan;
  final String tinggiBadan;
  final String lingkarBadan;
  final DateTime takeDate;
  final String documentID;

  DataTumbuh(
      {this.idPeserta,
      this.idMedis,
      this.nama,
      this.email,
      this.tgllahir,
      this.beratBadan,
      this.tinggiBadan,
      this.lingkarBadan,
      this.takeDate,
      this.documentID});
  Map<String, dynamic> toMap() {
    return {
      "idMedis": idMedis,
      "idPeserta": idPeserta,
      "nama": nama,
      "email": email,
      "tgllahir": tgllahir,
      "beratBadan": beratBadan,
      "tinggiBadan": tinggiBadan,
      "lingkarBadan": lingkarBadan,
      "take_date": takeDate,
    };
  }
}

class DataRiwayatImunisasi {
  final String idMedis;
  final String idPeserta;
  final String nama;
  final String email;
  final String tgllahir;
  final String jenisVaksin;
  final String namaMedis;
  final DateTime takeDate;
  final String documentID;

  DataRiwayatImunisasi(
      {this.idPeserta,
      this.idMedis,
      this.nama,
      this.email,
      this.tgllahir,
      this.jenisVaksin,
      this.namaMedis,
      this.takeDate,
      this.documentID});
  Map<String, dynamic> toMap() {
    return {
      "idMedis": idMedis,
      "idPeserta": idPeserta,
      "nama": nama,
      "email": email,
      "tgllahir": tgllahir,
      "jenisVaksin": jenisVaksin,
      "namaMedis": namaMedis,
      "take_date": takeDate,
    };
  }
}
